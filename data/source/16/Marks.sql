USE [Great School]
GO

/****** Object:  Table [dbo].[Marks]    Script Date: 11/24/2023 5:56:59 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[Marks](
	[MarkID] [int] IDENTITY(1,1) NOT NULL,
	[StudentID] [int] NULL,
	[SubjectID] [int] NULL,
	[TeacherID] [int] NULL,
	[MarkObtained] [int] NULL,
	[ExamDate] [date] NULL,
PRIMARY KEY CLUSTERED 
(
	[MarkID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[Marks]  WITH CHECK ADD  CONSTRAINT [FK_Student] FOREIGN KEY([StudentID])
REFERENCES [dbo].[Students] ([StudentID])
GO

ALTER TABLE [dbo].[Marks] CHECK CONSTRAINT [FK_Student]
GO

ALTER TABLE [dbo].[Marks]  WITH CHECK ADD  CONSTRAINT [FK_Subject] FOREIGN KEY([SubjectID])
REFERENCES [dbo].[Subjects] ([SubjectID])
GO

ALTER TABLE [dbo].[Marks] CHECK CONSTRAINT [FK_Subject]
GO

ALTER TABLE [dbo].[Marks]  WITH CHECK ADD  CONSTRAINT [FK_Teacher] FOREIGN KEY([TeacherID])
REFERENCES [dbo].[Teachers] ([TeacherID])
GO

ALTER TABLE [dbo].[Marks] CHECK CONSTRAINT [FK_Teacher]
GO

