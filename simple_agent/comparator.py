import hashlib
from copy import deepcopy
from decimal import ROUND_HALF_UP, ROUND_FLOOR, ROUND_CEILING, Decimal, InvalidOperation
from typing import Dict, List, Any, Tuple, Optional


# ==========================================
# 核心比对服务
# ==========================================

def md5_list(values: List[Any]) -> str:
    """计算列表内容的 MD5，用于快速比对列"""
    s = ",".join([str(v) if v is not None else "" for v in values])
    return hashlib.md5(s.encode("utf-8")).hexdigest()


def normalize_string(s: str) -> str:
    """字符串清洗函数"""
    if s is None: return ""
    # 处理类似日期前缀的特殊逻辑
    if len(s) >= 10 and s[4] == '-' and s[7] == '-':
        prefix = s[:10]
        if prefix.replace('-', '').isdigit():
            s = prefix
    return "".join([c for c in s if ord(c) < 128])


def accurate_decimal(table: Dict[str, List[Any]], scale: int = 2, strategy: str = 'round') -> Dict[str, List[str]]:
    """
    数据标准化函数：处理数值精度、Null值和布尔值
    strategy: 'round' (四舍五入), 'floor' (取整), 'raw' (保留原始字符串但清洗格式)
    """
    out = {}
    for k, col in table.items():
        new_col = []
        for v in col:
            if v is None:
                new_col.append("")
                continue

            vs_raw = str(v)
            vs_lower = vs_raw.lower()

            if vs_lower == "null":
                new_col.append("")
                continue
            if vs_lower == 'true':
                vs = "1"
            elif vs_lower == 'false':
                vs = "0"
            else:
                vs = vs_raw

            # 尝试作为数字处理
            try:
                d = Decimal(vs)
                if strategy == 'floor':
                    new_col.append(str(int(d)))
                elif strategy == 'round':
                    new_col.append(
                        str(d.quantize(Decimal("1." + "0" * scale), rounding=ROUND_HALF_UP))
                    )
                elif strategy == 'raw':
                    # Raw 模式下，如果是合法数字，转为标准字符串（去除多余的 + 号等），否则保留原样
                    # 这里为了后续精度判断，保留 Decimal 的字符串形式
                    new_col.append(str(d))
                else:
                    new_col.append(normalize_string(vs_raw))
            except Exception:
                # 无法转数字则作为普通字符串处理
                new_col.append(normalize_string(vs_raw))
        out[k] = new_col
    return out


class Evaluator:
    def compare(self, standard_answers: List[Dict[str, List[Any]]], target_result: Dict[str, List[Any]],
                is_order: bool) -> bool:
        """
        比对执行结果与标准答案列表。
        """
        if not target_result:
            return False

        if isinstance(standard_answers, dict):
            standard_answers = [standard_answers]

        if not standard_answers:
            return False

        target_result = {k.strip(): v for k, v in target_result.items()}

        for std in standard_answers:
            if not isinstance(std, dict):
                continue
            std = {k.strip(): v for k, v in std.items()}

            # === 第一轮比对：严格模式 (Round, Scale=2) ===
            # 利用 MD5 快速比对
            if self._quick_compare(std, target_result, is_order, scale=2, strategy='round'):
                return True

            # === 第二轮比对：宽松模式 (Floor/Integer) ===
            # 利用 MD5 快速比对
            if self._quick_compare(std, target_result, is_order, strategy='floor'):
                return True

            # === 第三轮比对：智能模糊模式 (Fuzzy Numeric) ===
            # 针对题目要求的“如果执行结果小数位多，尝试截断/取整后比对”
            # 此模式不使用 MD5，而是逐值比对
            if self._compare_fuzzy(std, target_result, is_order):
                return True

        return False

    def _quick_compare(self, std: Dict[str, List[Any]], tgt: Dict[str, List[Any]],
                       is_order: bool, scale: int = 2, strategy: str = 'round') -> bool:
        """使用原有的标准化+MD5/排序逻辑进行快速比对"""
        std_fmt = accurate_decimal(deepcopy(std), scale=scale, strategy=strategy)
        tgt_fmt = accurate_decimal(deepcopy(tgt), scale=scale, strategy=strategy)

        if is_order:
            return self._compare_ordered_strict(std_fmt, tgt_fmt)
        else:
            return self._compare_unordered_strict(std_fmt, tgt_fmt)

    def _compare_ordered_strict(self, std: Dict[str, List[str]], tgt: Dict[str, List[str]]) -> bool:
        try:
            if not std or not tgt: return False
            if len(next(iter(std.values()))) != len(next(iter(tgt.values()))):
                return False

            std_md5 = {md5_list(vals) for vals in std.values()}
            tgt_md5 = {md5_list(vals) for vals in tgt.values()}
            return std_md5 == tgt_md5
        except Exception:
            return False

    def _compare_unordered_strict(self, std: Dict[str, List[str]], tgt: Dict[str, List[str]]) -> bool:
        try:
            # 1. 映射列
            tgt_cols_info = []
            for k, col_vals in tgt.items():
                lst = sorted(["" if v is None else str(v) for v in col_vals])
                tgt_cols_info.append((k, md5_list(lst)))

            aligned_tgt_keys = []
            used_tgt_indices = set()

            for std_vals in std.values():
                std_lst = sorted(["" if v is None else str(v) for v in std_vals])
                std_md5 = md5_list(std_lst)

                found = False
                for idx, (tgt_k, tgt_md5) in enumerate(tgt_cols_info):
                    if idx not in used_tgt_indices and tgt_md5 == std_md5:
                        used_tgt_indices.add(idx)
                        aligned_tgt_keys.append(tgt_k)
                        found = True
                        break
                if not found: return False

            if len(aligned_tgt_keys) != len(std): return False

            # 2. 排序行并比对
            rows_std = self._table_to_sorted_rows(std, list(std.keys()))
            rows_tgt = self._table_to_sorted_rows(tgt, aligned_tgt_keys)
            return rows_std == rows_tgt
        except Exception:
            return False

    # ==========================================
    # 新增：智能模糊比对逻辑
    # ==========================================

    def _compare_fuzzy(self, std: Dict[str, List[Any]], tgt: Dict[str, List[Any]], is_order: bool) -> bool:
        """
        处理数值精度不一致的情况。
        策略：保留原始数据字符串，尝试对齐列，然后逐个单元格进行模糊匹配。
        """
        # 1. 获取 Raw 格式数据 (处理 Null/Bool，但不截断数字)
        std_raw = accurate_decimal(deepcopy(std), strategy='raw')
        tgt_raw = accurate_decimal(deepcopy(tgt), strategy='raw')

        # 2. 对齐列 (这里简化处理：尝试通过列名对齐，或者假设顺序一致)
        # 由于是 Fuzzy 模式，MD5 对齐可能失败。
        # 我们优先尝试按列名对齐，如果列名不匹配，则按索引对齐（假设 Schema 一致）
        std_keys = list(std_raw.keys())
        tgt_keys = list(tgt_raw.keys())

        aligned_tgt_keys = []

        # 尝试列名完全匹配
        if set(std_keys) == set(tgt_keys):
            aligned_tgt_keys = std_keys
        else:
            # 列名不匹配，回退到按索引对齐
            if len(std_keys) != len(tgt_keys):
                return False
            aligned_tgt_keys = tgt_keys

        # 3. 构建行列表
        # 为了支持无序比对，我们需要对行进行排序。
        # 即使数值有微小差异，只要差异不大，排序后的相对顺序通常保持一致。
        # 更好的方式是：如果 is_order=False，我们先按字符串排序行，然后逐行比对。

        rows_std = self._table_to_sorted_rows(std_raw, std_keys) if not is_order else self._table_to_rows(std_raw,
                                                                                                          std_keys)
        rows_tgt = self._table_to_sorted_rows(tgt_raw, aligned_tgt_keys) if not is_order else self._table_to_rows(
            tgt_raw, aligned_tgt_keys)

        if len(rows_std) != len(rows_tgt):
            return False

        # 4. 逐行逐格比对
        for r_std, r_tgt in zip(rows_std, rows_tgt):
            for val_std, val_tgt in zip(r_std, r_tgt):
                if not self._check_numeric_fuzzy_match(val_std, val_tgt):
                    return False

        return True

    def _check_numeric_fuzzy_match(self, std_val: str, tgt_val: str) -> bool:
        """
        核心数值比对逻辑：
        如果执行结果(tgt)的小数位数比标准答案(std)多，
        将执行结果 round/floor/ceil 到和标准答案一样的小数位数，再比较。
        """
        if std_val == tgt_val:
            return True

        try:
            d_std = Decimal(std_val)
            d_tgt = Decimal(tgt_val)
        except InvalidOperation:
            # 不是数字，直接字符串不相等
            return False

        # 获取小数位数
        std_scale = abs(d_std.as_tuple().exponent)
        tgt_scale = abs(d_tgt.as_tuple().exponent)

        # 只有当 Target 精度更高时才进行特殊处理
        if tgt_scale > std_scale:
            quantizer = Decimal("1." + "0" * std_scale)

            # 尝试1：向下取整 (Floor)
            if d_tgt.quantize(quantizer, rounding=ROUND_FLOOR) == d_std:
                return True

            # 尝试2：向上取整 (Ceiling)
            if d_tgt.quantize(quantizer, rounding=ROUND_CEILING) == d_std:
                return True

            # 尝试3：四舍五入 (Half Up) - 作为补充
            if d_tgt.quantize(quantizer, rounding=ROUND_HALF_UP) == d_std:
                return True

        # 如果精度没有更高，或者截断后仍不匹配，则认为不相等
        # (注意：Decimal比较时 1.00 和 1.0 是相等的，所以上面 d_std == d_tgt 已经覆盖了数值相等但格式不同的情况)
        return d_std == d_tgt

    def _table_to_rows(self, table: Dict[str, List[str]], col_order: List[str]) -> List[Tuple]:
        """将表转为行列表（保留原始顺序）"""
        if not table: return []
        return list(zip(*[table[k] for k in col_order]))

    def _table_to_sorted_rows(self, table: Dict[str, List[str]], col_order: List[str]) -> List[Tuple]:
        """将表转为行列表并排序"""
        rows = self._table_to_rows(table, col_order)
        # 排序键：尝试转为 Decimal 排序，失败则按字符串排序
        # 这样可以保证 '10' 排在 '2' 后面
        rows.sort(key=lambda row: tuple(self._sort_key(x) for x in row))
        return rows

    def _sort_key(self, val: str):
        """辅助排序键，优先按数字大小排序"""
        try:
            return (0, Decimal(val))
        except:
            return (1, val)