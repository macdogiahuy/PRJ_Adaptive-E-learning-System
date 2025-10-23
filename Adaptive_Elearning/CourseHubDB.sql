USE [master]
GO
/****** Object:  Database [CourseHubDB]    Script Date: 10/31/2023 1:26:53 PM ******/
CREATE DATABASE [CourseHubDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CourseHubDB', FILENAME = N'C:\Program Files\Microsoft SQL Server 2016\MSSQL13.SQL2016\MSSQL\DATA\CourseHubDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'CourseHubDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server 2016\MSSQL13.SQL2016\MSSQL\DATA\CourseHubDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [CourseHubDB] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [CourseHubDB].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [CourseHubDB] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [CourseHubDB] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [CourseHubDB] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [CourseHubDB] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [CourseHubDB] SET ARITHABORT OFF 
GO
ALTER DATABASE [CourseHubDB] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [CourseHubDB] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [CourseHubDB] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [CourseHubDB] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [CourseHubDB] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [CourseHubDB] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [CourseHubDB] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [CourseHubDB] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [CourseHubDB] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [CourseHubDB] SET  ENABLE_BROKER 
GO
ALTER DATABASE [CourseHubDB] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [CourseHubDB] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [CourseHubDB] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [CourseHubDB] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [CourseHubDB] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [CourseHubDB] SET READ_COMMITTED_SNAPSHOT ON 
GO
ALTER DATABASE [CourseHubDB] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [CourseHubDB] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [CourseHubDB] SET  MULTI_USER 
GO
ALTER DATABASE [CourseHubDB] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [CourseHubDB] SET DB_CHAINING OFF 
GO
ALTER DATABASE [CourseHubDB] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [CourseHubDB] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [CourseHubDB] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [CourseHubDB] SET QUERY_STORE = OFF
GO
USE [CourseHubDB]
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
USE [CourseHubDB]
GO
/****** Object:  User [WarmIIS]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE USER [WarmIIS] FOR LOGIN [IIS APPPOOL\WarmIIS] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [WarmIIS]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [WarmIIS]
GO
/****** Object:  Table [dbo].[__EFMigrationsHistory]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[__EFMigrationsHistory](
	[MigrationId] [nvarchar](150) NOT NULL,
	[ProductVersion] [nvarchar](32) NOT NULL,
 CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY CLUSTERED 
(
	[MigrationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Articles]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Articles](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](3000) NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Status] [varchar](45) NOT NULL,
	[IsCommentDisabled] [bit] NOT NULL,
	[CommentCount] [int] NOT NULL,
	[ViewCount] [int] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Articles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Assignments]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Assignments](
	[Id] [uniqueidentifier] NOT NULL,
	[Name] [nvarchar](255) NOT NULL,
	[Duration] [int] NOT NULL,
	[QuestionCount] [int] NOT NULL,
	[SectionId] [uniqueidentifier] NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[GradeToPass] [float] NOT NULL,
 CONSTRAINT [PK_Assignments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Bills]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Bills](
	[Id] [uniqueidentifier] NOT NULL,
	[Action] [varchar](100) NOT NULL,
	[Note] [nvarchar](255) NOT NULL,
	[Amount] [bigint] NOT NULL,
	[Gateway] [varchar](20) NOT NULL,
	[TransactionId] [varchar](100) NOT NULL,
	[ClientTransactionId] [varchar](100) NOT NULL,
	[Token] [varchar](100) NOT NULL,
	[IsSuccessful] [bit] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Bills] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Categories]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Categories](
	[Id] [uniqueidentifier] NOT NULL,
	[Path] [varchar](255) NOT NULL,
	[Title] [varchar](100) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[IsLeaf] [bit] NOT NULL,
	[CourseCount] [int] NOT NULL,
 CONSTRAINT [PK_Categories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ChatMessages]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ChatMessages](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](255) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[ConversationId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_ChatMessages] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CommentMedia]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommentMedia](
	[CommentId] [uniqueidentifier] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Url] [varchar](255) NOT NULL,
 CONSTRAINT [PK_CommentMedia] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](500) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[SourceType] [nvarchar](max) NOT NULL,
	[ParentId] [uniqueidentifier] NULL,
	[LectureId] [uniqueidentifier] NULL,
	[ArticleId] [uniqueidentifier] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[ConversationMembers]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ConversationMembers](
	[CreatorId] [uniqueidentifier] NOT NULL,
	[ConversationId] [uniqueidentifier] NOT NULL,
	[IsAdmin] [bit] NOT NULL,
	[LastVisit] [datetime2](7) NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_ConversationMembers] PRIMARY KEY CLUSTERED 
(
	[CreatorId] ASC,
	[ConversationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Conversations]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Conversations](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](45) NOT NULL,
	[IsPrivate] [bit] NOT NULL,
	[AvatarUrl] [nvarchar](255) NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Conversations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseMeta]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseMeta](
	[CourseId] [uniqueidentifier] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [tinyint] NOT NULL,
	[Value] [nvarchar](100) NOT NULL,
 CONSTRAINT [PK_CourseMeta] PRIMARY KEY CLUSTERED 
(
	[CourseId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[CourseReviews]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CourseReviews](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](500) NOT NULL,
	[Rating] [tinyint] NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_CourseReviews] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Courses]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[MetaTitle] [varchar](255) NOT NULL,
	[ThumbUrl] [nvarchar](255) NOT NULL,
	[Intro] [nvarchar](500) NOT NULL,
	[Description] [nvarchar](1000) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[Price] [float] NOT NULL,
	[Discount] [float] NOT NULL,
	[DiscountExpiry] [datetime2](7) NOT NULL,
	[Level] [nvarchar](max) NOT NULL,
	[Outcomes] [nvarchar](500) NOT NULL,
	[Requirements] [nvarchar](500) NOT NULL,
	[LectureCount] [tinyint] NOT NULL,
	[LearnerCount] [int] NOT NULL,
	[RatingCount] [int] NOT NULL,
	[TotalRating] [bigint] NOT NULL,
	[LeafCategoryId] [uniqueidentifier] NOT NULL,
	[InstructorId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Enrollments]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Enrollments](
	[CreatorId] [uniqueidentifier] NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[BillId] [uniqueidentifier] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[AssignmentMilestones] [nvarchar](max) NOT NULL,
	[LectureMilestones] [nvarchar](max) NOT NULL,
	[SectionMilestones] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_Enrollments] PRIMARY KEY CLUSTERED 
(
	[CreatorId] ASC,
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Instructors]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Instructors](
	[Id] [uniqueidentifier] NOT NULL,
	[Intro] [nvarchar](500) NOT NULL,
	[Experience] [nvarchar](1000) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[Balance] [bigint] NOT NULL,
	[CourseCount] [tinyint] NOT NULL,
 CONSTRAINT [PK_Instructors] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[LectureMaterial]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[LectureMaterial](
	[LectureId] [uniqueidentifier] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Url] [varchar](255) NOT NULL,
 CONSTRAINT [PK_LectureMaterial] PRIMARY KEY CLUSTERED 
(
	[LectureId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Lectures]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Lectures](
	[Id] [uniqueidentifier] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[Content] [nvarchar](3000) NOT NULL,
	[SectionId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[IsPreviewable] [bit] NOT NULL,
 CONSTRAINT [PK_Lectures] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[McqChoices]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[McqChoices](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](255) NOT NULL,
	[IsCorrect] [bit] NOT NULL,
	[McqQuestionId] [uniqueidentifier] NULL,
 CONSTRAINT [PK_McqChoices] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[McqQuestions]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[McqQuestions](
	[Id] [uniqueidentifier] NOT NULL,
	[Content] [nvarchar](500) NOT NULL,
	[AssignmentId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_McqQuestions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[McqUserAnswer]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[McqUserAnswer](
	[SubmissionId] [uniqueidentifier] NOT NULL,
	[MCQChoiceId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_McqUserAnswer] PRIMARY KEY CLUSTERED 
(
	[SubmissionId] ASC,
	[MCQChoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Notifications]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Notifications](
	[Id] [uniqueidentifier] NOT NULL,
	[Message] [nvarchar](255) NOT NULL,
	[Type] [nvarchar](max) NOT NULL,
	[Status] [nvarchar](max) NOT NULL,
	[ReceiverId] [uniqueidentifier] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Notifications] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Reactions]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Reactions](
	[CreatorId] [uniqueidentifier] NOT NULL,
	[SourceEntityId] [uniqueidentifier] NOT NULL,
	[Content] [varchar](10) NOT NULL,
	[SourceType] [nvarchar](max) NOT NULL,
	[ArticleId] [uniqueidentifier] NULL,
	[ChatMessageId] [uniqueidentifier] NULL,
	[CommentId] [uniqueidentifier] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Reactions] PRIMARY KEY CLUSTERED 
(
	[CreatorId] ASC,
	[SourceEntityId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Sections]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Sections](
	[Id] [uniqueidentifier] NOT NULL,
	[Index] [tinyint] NOT NULL,
	[Title] [nvarchar](255) NOT NULL,
	[LectureCount] [tinyint] NOT NULL,
	[CourseId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Sections] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Submissions]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Submissions](
	[Id] [uniqueidentifier] NOT NULL,
	[Mark] [float] NOT NULL,
	[TimeSpentInSec] [int] NOT NULL,
	[AssignmentId] [uniqueidentifier] NOT NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[CreatorId] [uniqueidentifier] NOT NULL,
	[LastModifierId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_Submissions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tag]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tag](
	[ArticleId] [uniqueidentifier] NOT NULL,
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](45) NOT NULL,
 CONSTRAINT [PK_Tag] PRIMARY KEY CLUSTERED 
(
	[ArticleId] ASC,
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Users]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [uniqueidentifier] NOT NULL,
	[UserName] [varchar](45) NOT NULL,
	[Password] [varchar](100) NOT NULL,
	[Email] [varchar](45) NOT NULL,
	[FullName] [nvarchar](45) NOT NULL,
	[MetaFullName] [varchar](45) NOT NULL,
	[AvatarUrl] [varchar](100) NOT NULL,
	[Role] [nvarchar](max) NOT NULL,
	[Token] [varchar](100) NOT NULL,
	[RefreshToken] [varchar](100) NOT NULL,
	[IsVerified] [bit] NOT NULL,
	[IsApproved] [bit] NOT NULL,
	[AccessFailedCount] [tinyint] NOT NULL,
	[LoginProvider] [varchar](100) NULL,
	[ProviderKey] [varchar](100) NULL,
	[Bio] [nvarchar](1000) NOT NULL,
	[DateOfBirth] [datetime2](7) NULL,
	[Phone] [varchar](45) NULL,
	[EnrollmentCount] [int] NOT NULL,
	[InstructorId] [uniqueidentifier] NULL,
	[CreationTime] [datetime2](7) NOT NULL,
	[LastModificationTime] [datetime2](7) NOT NULL,
	[SystemBalance] [bigint] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20230923015142_M1_InitDb', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20230924155558_M2_Fix', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20230924164124_M3_Fix', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20230925004316_M4_Fix', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20230925043200_M5_Fix', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20231020082023_M6_Remove_Unnecessary', N'7.0.10')
INSERT [dbo].[__EFMigrationsHistory] ([MigrationId], [ProductVersion]) VALUES (N'20231020093943_M7_Assignment_Milestone', N'7.0.10')
GO
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'72930d6e-30a8-48d8-b8d0-130cd4f61ea1', N'Assignment #79', 30, 4, N'1c039d3e-acae-4445-6097-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'4cbd9f9c-55df-4752-a190-1c9daad20869', N'Assignment #38', 30, 3, N'e4a172d5-7ba2-4abd-6093-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'5519b20f-9f30-4a92-81e8-2b0fa1867c51', N'Assignment #4', 30, 0, N'fc495ebf-d6a8-4831-6094-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'740433a6-9745-42ce-b1d3-7293764c5bc1', N'Assignment #59', 30, 2, N'a1fcdc04-834c-4b5a-60ab-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'77d68364-fbd5-43dd-8720-926da682b0d7', N'Custom Assignment #934', 60, 6, N'de63cabe-3090-4cff-2320-08dbca099599', N'39dcb58a-5a86-4220-8366-518be3efe406', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'a1c19da3-4db4-4bf2-b2a5-a1d561b0b2ee', N'Assignment #80', 30, 2, N'dd92e208-b4e2-4e00-6091-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'6965b04a-e57a-4cc0-ac98-c19c61eaa497', N'Questions post-update', 50, 6, N'1f8f709e-85cd-45e4-1cde-08dbd464ab52', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3', N'section 3 assignment', 40, 6, N'ac97747b-ae84-4916-2325-08dbca099599', N'39dcb58a-5a86-4220-8366-518be3efe406', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'1eec3ded-baa0-4a3b-9244-c8ccae3699c5', N'Assignment #1', 30, 3, N'43081548-a9b2-48a3-60a0-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'4b894308-1681-4d39-bc30-cb6571e79f85', N'Assignment #37', 30, 2, N'098775e2-9545-4bfb-609f-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'4910d433-628f-42ab-9ad5-d5e861f89f17', N'Assignment #55', 30, 2, N'582345d4-fc88-4147-60aa-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'19700903-8b4b-47b9-a873-e2a4f068c45a', N'Assignment #1', 30, 5, N'798de95d-c6a9-40ef-60af-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'215adbdd-0b6d-40a5-95f1-effe85229b9e', N'Assignment #45', 30, 3, N'da9f330c-7616-4831-6090-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'7d55216c-dcd4-4013-8461-f1aac771417b', N'section 3 assignment #2', 50, 6, N'ac97747b-ae84-4916-2325-08dbca099599', N'39dcb58a-5a86-4220-8366-518be3efe406', 8)
INSERT [dbo].[Assignments] ([Id], [Name], [Duration], [QuestionCount], [SectionId], [CreatorId], [GradeToPass]) VALUES (N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', N'Assignment #74', 30, 2, N'484275b5-e6f3-4ccc-6089-08dbbbd82e06', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', 8)
GO
INSERT [dbo].[Bills] ([Id], [Action], [Note], [Amount], [Gateway], [TransactionId], [ClientTransactionId], [Token], [IsSuccessful], [CreationTime], [CreatorId]) VALUES (N'515ae820-4d3f-4d0f-a33e-3ef4d1396306', N'Pay for course', N'522d2265-0532-4142-8079-0aa7e9c7d3cb''s payment for course #69746c85-6109-4370-9334-1490cd2334b0', 6000000, N'VNPay', N'14129034', N'VNP14129034', N'', 1, CAST(N'2023-09-29T22:01:16.3566667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Bills] ([Id], [Action], [Note], [Amount], [Gateway], [TransactionId], [ClientTransactionId], [Token], [IsSuccessful], [CreationTime], [CreatorId]) VALUES (N'a138a1c0-6c56-4d58-8ee7-6d3e8d653e93', N'Pay for course', N'603d925c-147c-4d22-82cf-23633d1c4a80''s payment for course #76bf19f6-1221-4242-97bb-0355035a3389', 54000000, N'VNPay', N'14148808', N'VNP14148808', N'', 1, CAST(N'2023-10-19T21:14:36.8700000' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80')
INSERT [dbo].[Bills] ([Id], [Action], [Note], [Amount], [Gateway], [TransactionId], [ClientTransactionId], [Token], [IsSuccessful], [CreationTime], [CreatorId]) VALUES (N'bf31bd88-83b8-4c32-8465-98fb778b987a', N'Pay for course', N'bda2a548-450a-402e-a75a-9712bcc6fc31''s payment for course #a2d066b4-0935-4b5a-b651-4ea97ea41f69', 62000000, N'VNPay', N'14134608', N'VNP14134608', N'', 1, CAST(N'2023-10-06T14:31:35.5800000' AS DateTime2), N'bda2a548-450a-402e-a75a-9712bcc6fc31')
INSERT [dbo].[Bills] ([Id], [Action], [Note], [Amount], [Gateway], [TransactionId], [ClientTransactionId], [Token], [IsSuccessful], [CreationTime], [CreatorId]) VALUES (N'dd29609d-9656-4173-92c2-d44401cb29cb', N'Pay for course', N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79''s payment for course #69746c85-6109-4370-9334-1490cd2334b0', 6000000, N'VNPay', N'14134542', N'VNP14134542', N'', 1, CAST(N'2023-10-06T13:48:59.7000000' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79')
INSERT [dbo].[Bills] ([Id], [Action], [Note], [Amount], [Gateway], [TransactionId], [ClientTransactionId], [Token], [IsSuccessful], [CreationTime], [CreatorId]) VALUES (N'8378fe89-da94-406d-b0f3-f9784b5b6185', N'Pay for course', N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed''s payment for course #c538b99b-f724-4788-879f-adfe3b1a90ea', 2000000, N'VNPay', N'14150290', N'VNP14150290', N'', 1, CAST(N'2023-10-20T22:04:24.9566667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed')
GO
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'd78b5017-1dac-4295-ba74-01a20b245ab6', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_d78b5017-1dac-4295-ba74-01a20b245ab6', N'Economics', N'Learn about the principles of economics and how they apply to the real world.', 1, 3)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'eccf3209-5133-4931-b12d-01e14011f0ae', N'602e0134-5533-43ec-a1d5-b133113550b3_eccf3209-5133-4931-b12d-01e14011f0ae', N'Marketing Analytics & Automation', N'Learn how to use data and automation to improve your marketing campaigns.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'c6fb9ff0-2f34-4a03-9d4e-08886d86bd95', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_c6fb9ff0-2f34-4a03-9d4e-08886d86bd95', N'Entrepreneurship', N'Learn how to start and run your own business.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'e9f73d0b-9f8e-43d2-8669-0b53238765c4', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_e9f73d0b-9f8e-43d2-8669-0b53238765c4', N'Self Esteem & Confidence', N'Learn how to build your self-esteem and confidence.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'334e0721-3ea4-4555-8efd-165c4a510081', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_334e0721-3ea4-4555-8efd-165c4a510081', N'Management', N'Learn how to manage and lead a team effectively.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'6fa6d917-bf63-4360-912b-1792650ba32f', N'602e0134-5533-43ec-a1d5-b133113550b3_6fa6d917-bf63-4360-912b-1792650ba32f', N'Affiliate Marketing', N'Learn how to promote other people''s products or services and earn a commission on sales.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'667a1782-906e-48b4-b07a-243de55605dd', N'602e0134-5533-43ec-a1d5-b133113550b3_667a1782-906e-48b4-b07a-243de55605dd', N'Branding', N'Learn how to create and manage a strong brand identity for your business.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'82bb3723-9506-4dbe-95c6-27dcf1c5b482', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_82bb3723-9506-4dbe-95c6-27dcf1c5b482', N'Personal Productivity', N'Learn how to be more productive and get more done in less time.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'31e1c63a-4e23-44b0-b4e3-339a389574c7', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_31e1c63a-4e23-44b0-b4e3-339a389574c7', N'Accounting & Bookkeeping', N'Learn how to record and analyze financial transactions.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'a4504156-06b7-415e-91e7-33f21bc35981', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_a4504156-06b7-415e-91e7-33f21bc35981', N'Business Law', N'Learn about the legal aspects of running a business.', 1, 1)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'bcaab247-a0b6-4db7-94dd-37a4903b7f47', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_bcaab247-a0b6-4db7-94dd-37a4903b7f47', N'Other Personal Development', N'Learn about other personal development topics, such as time management, goal setting, and habit formation.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'Software Engineering', N'Learn how to design, develop, and maintain software systems.', 1, 4)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'547b6f66-1e38-4205-80a6-42b10db0d953', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_547b6f66-1e38-4205-80a6-42b10db0d953', N'Software Development Tools', N'Learn about different software development tools, such as IDEs, version control systems, and debuggers.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'cf1fcc12-0fe8-4aaa-9254-4389d46d6a97', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_cf1fcc12-0fe8-4aaa-9254-4389d46d6a97', N'Financial Modeling & Analysis', N'Learn how to create and analyze financial models to assess the financial performance of a business or investment.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'595ecdbd-b8e7-4b00-acb0-5044582e41c3', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_595ecdbd-b8e7-4b00-acb0-5044582e41c3', N'Software Testing', N'Learn how to test software to ensure that it meets requirements and is free of defects.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'Human Resources', N'Learn about the different aspects of human resources, such as recruitment, training, and employee relations.', 1, 4)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'6cdec724-0bfe-4e8b-ab74-50e9d5c27780', N'602e0134-5533-43ec-a1d5-b133113550b3_6cdec724-0bfe-4e8b-ab74-50e9d5c27780', N'Marketing Fundamentals', N'Learn the basics of marketing, such as target audience analysis, marketing mix, and campaign planning.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'fda51c6c-ff32-4e38-bea7-5684a3392d33', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_fda51c6c-ff32-4e38-bea7-5684a3392d33', N'Cryptocurrency & Blockchain', N'Learn about cryptocurrency and blockchain technology.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'7eec23ff-1081-47fd-8a26-5bfedb081067', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_7eec23ff-1081-47fd-8a26-5bfedb081067', N'No-Code Development', N'Learn how to develop software without writing code.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'e5be1e5e-6bbe-4563-847e-6391e8bdf050', N'602e0134-5533-43ec-a1d5-b133113550b3_e5be1e5e-6bbe-4563-847e-6391e8bdf050', N'Video & Mobile Marketing', N'Learn how to use video and mobile marketing to reach your target audience and promote your business.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'488994b2-8d08-4d5a-8aba-68678a5adb7a', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_488994b2-8d08-4d5a-8aba-68678a5adb7a', N'Happiness', N'Learn how to live a happier and more fulfilling life.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'ef219685-7ec7-4de5-b5f0-69c60101ddfc', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_ef219685-7ec7-4de5-b5f0-69c60101ddfc', N'Taxes', N'Learn about different types of taxes and how to file your taxes accurately.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'18545d19-ddda-43da-9d29-7034a815825f', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_18545d19-ddda-43da-9d29-7034a815825f', N'Project Management', N'Learn how to plan, execute, and monitor projects.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'0bd669c1-e479-4dff-a587-7035d7094973', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e_0bd669c1-e479-4dff-a587-7035d7094973', N'Network & Security', N'Learn about computer networks and security, such as firewalls and intrusion detection systems.', 1, 4)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'df0e9c1f-56ca-4ec2-bec4-74a7907db8c0', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_df0e9c1f-56ca-4ec2-bec4-74a7907db8c0', N'Career Development', N'Learn how to advance your career and achieve your professional goals.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'c3fba28b-240b-4807-9f86-78348b8598c5', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_c3fba28b-240b-4807-9f86-78348b8598c5', N'Mobile Development', N'Learn how to develop mobile applications for iOS and Android devices.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'3281f542-4b6d-44a8-ac30-791697ef6b34', N'602e0134-5533-43ec-a1d5-b133113550b3_3281f542-4b6d-44a8-ac30-791697ef6b34', N'Digital Marketing', N'Learn how to use digital channels, such as search engines, social media, and email, to market your products or services.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'a71da8cf-aa32-430d-87cc-7a91453bf705', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_a71da8cf-aa32-430d-87cc-7a91453bf705', N'Media', N'Learn about the different aspects of the media industry, such as journalism, film, and television.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'56772738-4b51-4979-87db-7af3b0597af1', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_56772738-4b51-4979-87db-7af3b0597af1', N'Other Business', N'Learn about other business topics, such as customer service, marketing, and finance.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'8f44c0ee-4d04-4be7-9f13-7bd7f2d2b425', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_8f44c0ee-4d04-4be7-9f13-7bd7f2d2b425', N'Leadership', N'Learn how to be an effective leader and inspire others.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'E-Commerce', N'Learn how to create and manage an online store.', 1, 4)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'4ea59194-0c39-4c98-8513-8d582c29ecd3', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_4ea59194-0c39-4c98-8513-8d582c29ecd3', N'Parenting & Relationships', N'Learn how to be a better parent and build stronger relationships.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'30346fe0-5caf-4b45-bec9-91bfe0f55977', N'30346fe0-5caf-4b45-bec9-91bfe0f55977', N'Development', N'Improve your skills and knowledge in a variety of areas.', 0, 4)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'e198bd2a-94a5-4963-92a6-950796608480', N'4b35a4fc-ab0c-4f7b-874f-d8e60ad33bac_e198bd2a-94a5-4963-92a6-950796608480', N'Arts & Crafts', N'Learn how to create beautiful and functional objects using a variety of materials and techniques.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'68065a5c-0e1d-48aa-91f3-951db2cc6a7b', N'4b35a4fc-ab0c-4f7b-874f-d8e60ad33bac_68065a5c-0e1d-48aa-91f3-951db2cc6a7b', N'Beauty & Makeup', N'Learn how to apply makeup to enhance your natural beauty.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'875f4ac7-1aa9-404e-b297-9705cdf65665', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_875f4ac7-1aa9-404e-b297-9705cdf65665', N'Other Finance & Accounting', N'Learn about other finance and accounting topics, such as auditing and financial planning.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'f17b78e0-69f6-486d-b89b-9969053d7912', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e_f17b78e0-69f6-486d-b89b-9969053d7912', N'Hardware', N'Learn about computer hardware, such as processors, memory, and storage devices.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'8f82fc3c-714f-409e-9e0e-9ed52ca738ce', N'602e0134-5533-43ec-a1d5-b133113550b3_8f82fc3c-714f-409e-9e0e-9ed52ca738ce', N'Other Marketing', N'Learn about other marketing topics, such as email marketing, event marketing, and direct marketing.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'6028999c-8545-41ea-9c83-a03a27d8801c', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_6028999c-8545-41ea-9c83-a03a27d8801c', N'Esoteric Practices', N'Learn about and practice esoteric practices, such as meditation, yoga, and tarot reading.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'2456ab2b-5c0a-4681-bd3f-a294668baf31', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_2456ab2b-5c0a-4681-bd3f-a294668baf31', N'Data Science', N'Learn how to collect, clean, and analyze data to extract meaningful insights.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'c6fa258e-4b6a-490f-ab96-a4471bebc270', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_c6fa258e-4b6a-490f-ab96-a4471bebc270', N'Web Development', N'Learn how to develop websites and web applications.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'83852f21-9f49-44e9-a118-ab2a6a080429', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_83852f21-9f49-44e9-a118-ab2a6a080429', N'Memory & Study Skills', N'Learn how to improve your memory and study skills.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'7da6d7e7-6dc4-4902-a74f-ac7161153486', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_7da6d7e7-6dc4-4902-a74f-ac7161153486', N'Motivation', N'Learn how to stay motivated and achieve your goals.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'Sales', N'Learn how to sell products or services to customers.', 1, 6)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'9253f485-bf32-49d0-bd85-af081b289b1f', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_9253f485-bf32-49d0-bd85-af081b289b1f', N'Money Management Tools', N'Learn about different money management tools and strategies to help you budget, save, and invest your money.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'21b4b6bc-4783-4d58-9752-af54a6e1c320', N'602e0134-5533-43ec-a1d5-b133113550b3_21b4b6bc-4783-4d58-9752-af54a6e1c320', N'Public Relations', N'Learn how to build and maintain positive relationships with the media and public.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'3d694be2-bae1-40d4-9521-b0e0488700e7', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_3d694be2-bae1-40d4-9521-b0e0488700e7', N'Operations', N'Learn about the different aspects of business operations, such as supply chain management and production planning.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'602e0134-5533-43ec-a1d5-b133113550b3', N'602e0134-5533-43ec-a1d5-b133113550b3', N'Marketing', N'Learn how to promote your products or services to your target audience.', 0, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'f1506914-d9b2-4355-855c-b28515ee8238', N'602e0134-5533-43ec-a1d5-b133113550b3_f1506914-d9b2-4355-855c-b28515ee8238', N'Content Marketing', N'Learn how to create and distribute valuable content to attract and engage customers.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'453767b1-a798-46d5-935f-b5657c757b17', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e_453767b1-a798-46d5-935f-b5657c757b17', N'Other IT & Software', N'Learn about other IT and software topics, such as databases, cloud computing, and machine learning.', 1, 1)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_75fef7cb-e841-493c-a999-b9b2cd3c970a', N'Personal Transformation', N'Learn how to transform your life and become the best version of yourself.', 1, 5)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e_a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'Operating Systems & Servers', N'Learn about operating systems and servers, such as Windows, Linux, and Unix.', 1, 6)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'0781dd18-7b7c-4a56-abe5-bcbedb3924e2', N'602e0134-5533-43ec-a1d5-b133113550b3_0781dd18-7b7c-4a56-abe5-bcbedb3924e2', N'Search Engine Optimization', N'fe4ce48f-b58b-4a5b-b72e-6bdb0b149f11', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'a148be9d-4079-4c32-bc00-bd69b7c3563b', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_a148be9d-4079-4c32-bc00-bd69b7c3563b', N'Investing & Trading', N'Learn how to invest and trade in different financial markets.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'9cb5b30e-3590-4879-b4c6-bd8e3d61103d', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_9cb5b30e-3590-4879-b4c6-bd8e3d61103d', N'Stress Management', N'Learn how to manage stress and improve your overall well-being.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'cb84df3b-1ac8-4aca-94f2-be21b8feb15c', N'602e0134-5533-43ec-a1d5-b133113550b3_cb84df3b-1ac8-4aca-94f2-be21b8feb15c', N'Growth Hacking', N'Learn how to use low-cost, creative marketing tactics to grow your business rapidly.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'39aea463-e0e9-448f-bc05-bed540639c32', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_39aea463-e0e9-448f-bc05-bed540639c32', N'Industry', N'Learn about different industries and their specific challenges and opportunities.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'9eb8e218-de1c-4b0d-ba2b-bfc9359afa63', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_9eb8e218-de1c-4b0d-ba2b-bfc9359afa63', N'Compliance', N'Learn about the different compliance regulations that businesses and individuals must follow.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'7a2d37cd-17d3-4abd-9f74-c10626093c9b', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_7a2d37cd-17d3-4abd-9f74-c10626093c9b', N'Personal Brand Building', N'Learn how to create and build a strong personal brand.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'43f77d00-c236-45ae-bc7d-c301368d3ddd', N'43f77d00-c236-45ae-bc7d-c301368d3ddd', N'Business', N'Learn the skills you need to start and grow your own business.', 0, 21)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'c6abfb5d-bde2-40ea-a6c7-c68642802d9e', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_c6abfb5d-bde2-40ea-a6c7-c68642802d9e', N'Communication', N'Learn how to communicate effectively in both written and oral form.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'47500d59-7407-4787-bdcf-c9a8dce36259', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_47500d59-7407-4787-bdcf-c9a8dce36259', N'Creativity', N'Learn how to boost your creativity and come up with new ideas.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'3e012f81-9ebb-4ca1-984b-cc124a95023f', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_3e012f81-9ebb-4ca1-984b-cc124a95023f', N'Influence', N'Learn how to influence others in a positive way.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'3faa004b-b10a-42ea-a68d-ce78e7c9f09f', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_3faa004b-b10a-42ea-a68d-ce78e7c9f09f', N'Game Development', N'Learn how to develop video games, from concept to design to implementation.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'd76a0078-7471-4bbf-b926-d44de77cbdcd', N'602e0134-5533-43ec-a1d5-b133113550b3_d76a0078-7471-4bbf-b926-d44de77cbdcd', N'Product Marketing', N'Learn how to create and market products that meet the needs of your target audience.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'aabbed15-82b9-4774-9294-d63ab40bb646', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_aabbed15-82b9-4774-9294-d63ab40bb646', N'Finance', N'Learn about different financial topics, such as corporate finance, personal finance, and public finance.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'4b35a4fc-ab0c-4f7b-874f-d8e60ad33bac', N'4b35a4fc-ab0c-4f7b-874f-d8e60ad33bac', N'Lifestyle', N'Learn how to live a healthier, happier, and more fulfilling life.', 0, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'7e49555c-feeb-44bd-a8d0-ddd4f7cf880f', N'602e0134-5533-43ec-a1d5-b133113550b3_7e49555c-feeb-44bd-a8d0-ddd4f7cf880f', N'Social Media Marketing', N'Learn how to use social media platforms, such as Twitter, Facebook, and Instagram, to connect with your target audience and promote your business.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7', N'Personal Development', N'Set and achieve your personal goals.', 0, 5)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'faa1cd81-9be8-436d-8f0b-e1cfb6647d1d', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_faa1cd81-9be8-436d-8f0b-e1cfb6647d1d', N'Business Strategy', N'Learn how to develop and implement a business strategy to achieve your business goals.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'10b56f9f-797b-4619-853e-e4883ed6842a', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_10b56f9f-797b-4619-853e-e4883ed6842a', N'Database Design & Development', N'Learn how to design and develop databases to store and manage data.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'423c6f50-1b74-48b8-990c-e98a78e0e42b', N'aa2f787b-2f0b-43f1-85b5-de5e66b65aa7_423c6f50-1b74-48b8-990c-e98a78e0e42b', N'Religion & Spirituality', N'Learn about different religions and spiritual practices.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65', N'Finance & Accounting', N'Learn how to manage your money and make sound financial decisions.', 0, 3)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'582a4383-feeb-4fcf-a096-eeef85cbb7f6', N'639e0f76-1b43-4b4f-a56a-e9a08ce35e65_582a4383-feeb-4fcf-a096-eeef85cbb7f6', N'Finance Cert & Exam Prep', N'Learn how to prepare for and pass finance certifications and exams.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'Business Analytics & Intelligence', N'Learn how to use data and analytics to improve your business decisions.', 1, 6)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'2ecdb67e-ac09-40db-9288-f798dca39f69', N'602e0134-5533-43ec-a1d5-b133113550b3_2ecdb67e-ac09-40db-9288-f798dca39f69', N'Paid Advertising', N'Learn how to create and run effective paid advertising campaigns on platforms such as Google Ads and Facebook Ads.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'f9d3a7d4-47a0-4d9f-9d2e-fa3fa7ec0eb0', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e_f9d3a7d4-47a0-4d9f-9d2e-fa3fa7ec0eb0', N'IT Certifications', N'Learn about IT certifications, such as the CompTIA A+ and Network+ certifications.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e', N'f5138b6a-caff-4cb8-a54f-fd06b5c6f78e', N'IT & Software', N'Learn about computers and software, and how to use them to solve problems.', 0, 11)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'3fcfc33a-0891-4664-acd4-fd6cceeeeb3e', N'43f77d00-c236-45ae-bc7d-c301368d3ddd_3fcfc33a-0891-4664-acd4-fd6cceeeeb3e', N'Real Estate', N'Learn about the different aspects of real estate, such as buying, selling, and investing in property.', 1, 0)
INSERT [dbo].[Categories] ([Id], [Path], [Title], [Description], [IsLeaf], [CourseCount]) VALUES (N'f055f1ae-4155-4efd-b123-ff88ab2201e6', N'30346fe0-5caf-4b45-bec9-91bfe0f55977_f055f1ae-4155-4efd-b123-ff88ab2201e6', N'Programming Languages', N'Learn about different programming languages, such as Python, Java, and JavaScript.', 1, 0)
GO
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'0bde0744-5235-4122-b86e-19407008a108', N'ní hảo', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:58:04.7566667' AS DateTime2), CAST(N'2023-10-03T16:58:04.7566667' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'75408f57-50a5-4176-9632-1c3fbdb34147', N'Chào buổi trưa', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:56:24.0333333' AS DateTime2), CAST(N'2023-10-03T16:56:24.0333333' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'9c3cfbd1-9c4e-4c5f-b579-21f486b9c1c4', N'Hi An', N'Delivered', N'ec7e3812-819b-40e6-a64a-ce8ca93504f4', CAST(N'2023-10-22T07:01:29.3800000' AS DateTime2), CAST(N'2023-10-22T07:01:29.3800000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'0a7d40ea-fbcc-488f-83e0-390a06689219', N'Chào buổi tối', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:57:50.3966667' AS DateTime2), CAST(N'2023-10-03T16:57:50.3966667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'6ef386f9-869c-4d02-a996-5a1222fed2d2', N'can you hear me', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-19T22:30:43.5466667' AS DateTime2), CAST(N'2023-10-19T22:30:43.5466667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'ddc524f9-40b2-43aa-b238-61f1de04c586', N'Hello Giang', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-06T14:34:39.0266667' AS DateTime2), CAST(N'2023-10-06T14:34:39.0266667' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'e187f0bf-225f-4374-9e4f-7072f6999bba', N'Tạm biệt', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:35:51.0133333' AS DateTime2), CAST(N'2023-10-03T16:35:51.0133333' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'95e889ac-162b-4a88-adf9-852c27f240e3', N'chào phong', N'Delivered', N'2ac72343-5543-456a-b1ff-ab973fc65a82', CAST(N'2023-10-28T14:07:14.3533333' AS DateTime2), CAST(N'2023-10-28T14:07:14.3533333' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'12c28e0b-24a2-46d9-866b-8a0b4990ce25', N'chào lộc', N'Delivered', N'08577382-ea3e-48df-9f8a-c82cf7750499', CAST(N'2023-10-28T14:07:06.5000000' AS DateTime2), CAST(N'2023-10-28T14:07:06.5000000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'd3fcdb10-4c4d-4bb0-b59f-8f5ce46493f5', N'hello world', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-19T22:30:30.6933333' AS DateTime2), CAST(N'2023-10-19T22:30:30.6933333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'df5dc9b2-e671-4c78-8004-99e341e528ba', N'haha 123', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:28:27.5800000' AS DateTime2), CAST(N'2023-10-03T16:28:27.5800000' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'5b60055d-e369-4339-ad5a-9b6bef7ebb53', N'Chào buổi sáng', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T16:55:42.3266667' AS DateTime2), CAST(N'2023-10-03T16:55:42.3266667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'240f4a85-ffdd-4af9-bc9a-a43f8049e73a', N'chào quỳnh', N'Delivered', N'c854f4c3-981f-4120-aef8-86f5490a09bb', CAST(N'2023-10-28T14:08:25.5300000' AS DateTime2), CAST(N'2023-10-28T14:08:25.5300000' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'cc9ee14c-e065-472e-a282-a9bf5c272474', N'hi', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-19T22:33:33.3933333' AS DateTime2), CAST(N'2023-10-19T22:33:33.3933333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'eff21511-3495-40a5-8edd-bc0993edc841', N'hello ', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-19T22:33:28.6000000' AS DateTime2), CAST(N'2023-10-19T22:33:28.6000000' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8fdf2b25-3e0e-4eb2-a27c-c0dbc1819b19', N'chào giang', N'Delivered', N'c854f4c3-981f-4120-aef8-86f5490a09bb', CAST(N'2023-10-28T14:07:39.2166667' AS DateTime2), CAST(N'2023-10-28T14:07:39.2166667' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'de3946b1-10de-4c19-8e4f-d302bde7ed1d', N'hi', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-24T14:25:14.1733333' AS DateTime2), CAST(N'2023-10-24T14:25:14.1733333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'd97508f8-50b5-40c4-a7bc-db2dd6d1e2ed', N'Hello world', N'Delivered', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', CAST(N'2023-10-03T15:33:25.7233333' AS DateTime2), CAST(N'2023-10-03T15:33:25.7233333' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[ChatMessages] ([Id], [Content], [Status], [ConversationId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'd89791f6-98ef-4c25-8a9a-ebe6883bbcd8', N'hello', N'Delivered', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', CAST(N'2023-10-24T14:29:54.1500000' AS DateTime2), CAST(N'2023-10-24T14:29:54.1500000' AS DateTime2), N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', N'00000000-0000-0000-0000-000000000000')
GO
INSERT [dbo].[Comments] ([Id], [Content], [Status], [SourceType], [ParentId], [LectureId], [ArticleId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'7a3a5f73-3e2a-4120-8111-2f139a0ce10b', N'Bài giảng thật dễ hiểu!', N'None', N'Lecture', NULL, N'0f9acec4-3fe3-4c23-cc27-08dbbbda1458', NULL, CAST(N'2023-10-08T18:32:33.0866667' AS DateTime2), CAST(N'2023-10-08T18:32:33.0866667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Comments] ([Id], [Content], [Status], [SourceType], [ParentId], [LectureId], [ArticleId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'a15d1a48-a21a-401e-af08-92061c3a66c9', N'Bài giảng quá ok!', N'None', N'Lecture', NULL, N'0f9acec4-3fe3-4c23-cc27-08dbbbda1458', NULL, CAST(N'2023-10-17T15:23:15.9700000' AS DateTime2), CAST(N'2023-10-17T15:23:15.9700000' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
GO
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'820ef64f-8e25-4486-86e5-027d4fddb31d', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-19T22:16:50.4792930' AS DateTime2), CAST(N'2023-10-19T22:16:50.5000000' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', 0, CAST(N'2023-10-02T16:49:23.2460565' AS DateTime2), CAST(N'2023-10-02T16:49:23.4866667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'c854f4c3-981f-4120-aef8-86f5490a09bb', 0, CAST(N'2023-10-28T14:07:33.4522109' AS DateTime2), CAST(N'2023-10-28T14:07:33.5966667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'75d60c97-b560-4779-9a31-c5855c24def1', 0, CAST(N'2023-10-13T22:56:56.1788176' AS DateTime2), CAST(N'2023-10-13T22:56:56.4433333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'f2eb3e5c-a462-49b2-acd4-48c98b2135bb', 1, CAST(N'2023-10-09T20:15:44.7683286' AS DateTime2), CAST(N'2023-10-09T20:15:44.7900000' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'75d60c97-b560-4779-9a31-c5855c24def1', 1, CAST(N'2023-10-12T15:45:31.2394754' AS DateTime2), CAST(N'2023-10-12T15:45:31.6266667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'ec7e3812-819b-40e6-a64a-ce8ca93504f4', 1, CAST(N'2023-10-09T20:14:54.9610914' AS DateTime2), CAST(N'2023-10-09T20:14:55.5633333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 1, CAST(N'2023-10-19T22:07:46.2430152' AS DateTime2), CAST(N'2023-10-19T22:07:46.3233333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'c27d91fe-ae29-4d9c-9b01-efcb943a8a62', 1, CAST(N'2023-10-09T20:23:53.8843439' AS DateTime2), CAST(N'2023-10-09T20:23:54.1366667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-24T14:27:22.5416867' AS DateTime2), CAST(N'2023-10-24T14:27:22.7800000' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'603d925c-147c-4d22-82cf-23633d1c4a80', N'75d60c97-b560-4779-9a31-c5855c24def1', 0, CAST(N'2023-10-12T15:45:31.2394729' AS DateTime2), CAST(N'2023-10-12T15:45:31.6266667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'603d925c-147c-4d22-82cf-23633d1c4a80', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-19T22:07:46.2430139' AS DateTime2), CAST(N'2023-10-19T22:07:46.3233333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'24acd35b-c23f-463c-95c9-27c9fef6c336', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-19T22:07:46.2430146' AS DateTime2), CAST(N'2023-10-19T22:07:46.3233333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'39dcb58a-5a86-4220-8366-518be3efe406', N'08577382-ea3e-48df-9f8a-c82cf7750499', 0, CAST(N'2023-10-09T20:27:17.9202950' AS DateTime2), CAST(N'2023-10-09T20:27:18.3966667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'39dcb58a-5a86-4220-8366-518be3efe406', N'c27d91fe-ae29-4d9c-9b01-efcb943a8a62', 0, CAST(N'2023-10-09T20:23:53.8843007' AS DateTime2), CAST(N'2023-10-09T20:23:54.1366667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'1a372bae-b8e0-40e7-b0f1-616312348a53', N'2ac72343-5543-456a-b1ff-ab973fc65a82', 0, CAST(N'2023-10-09T20:26:05.1484381' AS DateTime2), CAST(N'2023-10-09T20:26:05.1833333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'1a372bae-b8e0-40e7-b0f1-616312348a53', N'75d60c97-b560-4779-9a31-c5855c24def1', 0, CAST(N'2023-10-12T15:45:31.2394752' AS DateTime2), CAST(N'2023-10-12T15:45:31.6266667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'e6d6fab7-2cb9-4497-a132-669da88dc433', N'd683c0d3-ffd6-430b-acf3-c13581a80c93', 0, CAST(N'2023-10-09T14:05:23.2644591' AS DateTime2), CAST(N'2023-10-09T14:05:23.7933333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', 1, CAST(N'2023-10-02T16:49:23.2460784' AS DateTime2), CAST(N'2023-10-02T16:49:23.4866667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'd683c0d3-ffd6-430b-acf3-c13581a80c93', 1, CAST(N'2023-10-09T14:05:23.2644592' AS DateTime2), CAST(N'2023-10-09T14:05:23.7933333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'bda2a548-450a-402e-a75a-9712bcc6fc31', N'75d60c97-b560-4779-9a31-c5855c24def1', 0, CAST(N'2023-10-12T15:45:31.2393633' AS DateTime2), CAST(N'2023-10-12T15:45:31.6266667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'548bc0c0-d691-497f-a3e4-99e1fe5e25ed', N'f2eb3e5c-a462-49b2-acd4-48c98b2135bb', 0, CAST(N'2023-10-09T20:15:44.7683268' AS DateTime2), CAST(N'2023-10-09T20:15:44.7900000' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'548bc0c0-d691-497f-a3e4-99e1fe5e25ed', N'd683c0d3-ffd6-430b-acf3-c13581a80c93', 0, CAST(N'2023-10-09T14:05:23.2643822' AS DateTime2), CAST(N'2023-10-09T14:05:23.7933333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'548bc0c0-d691-497f-a3e4-99e1fe5e25ed', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-19T22:07:46.2430132' AS DateTime2), CAST(N'2023-10-19T22:07:46.3233333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'7a7bb1cd-25f9-4d44-8f8e-9a8d10d2eb98', N'd683c0d3-ffd6-430b-acf3-c13581a80c93', 0, CAST(N'2023-10-09T14:05:23.2644590' AS DateTime2), CAST(N'2023-10-09T14:05:23.7933333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'7a7bb1cd-25f9-4d44-8f8e-9a8d10d2eb98', N'75d60c97-b560-4779-9a31-c5855c24def1', 0, CAST(N'2023-10-12T15:45:31.2394753' AS DateTime2), CAST(N'2023-10-12T15:45:31.6266667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'b8db9868-81b1-4fd9-80aa-bb1fb45ce337', N'ec7e3812-819b-40e6-a64a-ce8ca93504f4', 0, CAST(N'2023-10-09T20:14:54.9610232' AS DateTime2), CAST(N'2023-10-09T20:14:55.5633333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'b8db9868-81b1-4fd9-80aa-bb1fb45ce337', N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', 0, CAST(N'2023-10-19T22:07:46.2428287' AS DateTime2), CAST(N'2023-10-19T22:07:46.3233333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'221c8992-0471-4524-b631-ca4bc6369315', N'd683c0d3-ffd6-430b-acf3-c13581a80c93', 0, CAST(N'2023-10-09T14:05:23.2644588' AS DateTime2), CAST(N'2023-10-09T14:05:23.7933333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'c854f4c3-981f-4120-aef8-86f5490a09bb', 1, CAST(N'2023-10-28T14:07:33.4523535' AS DateTime2), CAST(N'2023-10-28T14:07:33.5966667' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'2ac72343-5543-456a-b1ff-ab973fc65a82', 1, CAST(N'2023-10-09T20:26:05.1484395' AS DateTime2), CAST(N'2023-10-09T20:26:05.1833333' AS DateTime2))
INSERT [dbo].[ConversationMembers] ([CreatorId], [ConversationId], [IsAdmin], [LastVisit], [CreationTime]) VALUES (N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'08577382-ea3e-48df-9f8a-c82cf7750499', 1, CAST(N'2023-10-09T20:27:17.9205091' AS DateTime2), CAST(N'2023-10-09T20:27:18.3966667' AS DateTime2))
GO
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'f2eb3e5c-a462-49b2-acd4-48c98b2135bb', N'', 1, N'', CAST(N'2023-10-09T20:15:44.7900000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'e11a6568-9a2d-4886-b7b2-810f7f9bf2ea', N'', 1, N'', CAST(N'2023-10-02T16:49:23.4100000' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'c854f4c3-981f-4120-aef8-86f5490a09bb', N'', 1, N'', CAST(N'2023-10-28T14:07:33.5933333' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'2ac72343-5543-456a-b1ff-ab973fc65a82', N'', 1, N'', CAST(N'2023-10-09T20:26:05.1800000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'd683c0d3-ffd6-430b-acf3-c13581a80c93', N'My Learning Group', 0, N'Conversations/d683c0d3-ffd6-430b-acf3-c13581a80c93.jpg', CAST(N'2023-10-09T14:05:23.7866667' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'75d60c97-b560-4779-9a31-c5855c24def1', N'Learning Group #2', 0, N'Conversations/75d60c97-b560-4779-9a31-c5855c24def1.jpg', CAST(N'2023-10-12T15:45:31.6133333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'08577382-ea3e-48df-9f8a-c82cf7750499', N'', 1, N'', CAST(N'2023-10-09T20:27:18.3966667' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'ec7e3812-819b-40e6-a64a-ce8ca93504f4', N'', 1, N'', CAST(N'2023-10-09T20:14:55.5600000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7', N'Team C# NEW', 0, N'Conversations/22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7.jpg', CAST(N'2023-10-19T22:07:46.3100000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Conversations] ([Id], [Title], [IsPrivate], [AvatarUrl], [CreationTime], [CreatorId]) VALUES (N'c27d91fe-ae29-4d9c-9b01-efcb943a8a62', N'', 1, N'', CAST(N'2023-10-09T20:23:54.1366667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
GO
INSERT [dbo].[CourseReviews] ([Id], [Content], [Rating], [CourseId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'5437e19d-d016-4c2a-d511-08dbc48644b2', N'Khóa học quá ok, rẻ mà chất lượng quá, mình học vài tuần đã làm được', 5, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-10-04T10:01:56.9300000' AS DateTime2), CAST(N'2023-10-04T10:01:56.9300000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[CourseReviews] ([Id], [Content], [Rating], [CourseId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'52f2b66b-43d9-4712-9c6d-08dbc6386323', N'Khóa học quá ok!', 4, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-10-06T13:49:28.7300000' AS DateTime2), CAST(N'2023-10-17T05:04:18.0816250' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[CourseReviews] ([Id], [Content], [Rating], [CourseId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'17caf6ad-dc6b-4a0b-0c5d-08dbd0b1d9f6', N'5/5 great course!', 5, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-10-19T21:44:08.7933333' AS DateTime2), CAST(N'2023-10-19T14:56:35.6692183' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80', N'00000000-0000-0000-0000-000000000000')
GO
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'76bf19f6-1221-4242-97bb-0355035a3389', N'LinkedIn Marketing, Lead Generation & B2B Sales for LinkedIn', N'linkedin marketing  lead generation   b2b sales for linkedin', N'https://img-b.udemycdn.com/course/750x422/1794901_d8ac_2.jpg', N'LinkedIn Machine: The LinkedIn MasterClass to learn LinkedIn Marketing, Lead Generation, Business Development, B2B Sales', N'LinkedIn Marketing, Lead Generation & B2B Sales for LinkedIn', N'Ongoing', 540000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>How generate a massive amount of leads using cutting edge sales & marketing LinkedIn lead generation strategies</p><p>How to optimize your LinkedIn Profile to get 10x more visibility and generate leads</p><p>How to convert LinkedIn leads and conversations into REAL meetings via phone or in-person</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 1, 1, 5, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-09-29T10:29:23.6466667' AS DateTime2), CAST(N'2023-09-29T10:29:23.6466667' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'bf17dbaa-5185-4b03-a559-06ce94607ad5', N'Developing Emotional Intelligence in Teams', N'developing emotional intelligence in teams', N'https://img-c.udemycdn.com/course/750x422/934526_b707_4.jpg', N'Maximise Team Performance: Strategies for Developing Emotional Intelligence In Teams | Enhancing Relationships', N'Developing Emotional Intelligence in Teams', N'Ongoing', 99000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Intermediate', N'<p>Identify how team working through emotional intelligence can lead to better outcomes</p><p>Explore how people can behave and react to change and the emotions experienced in change</p><p>Recognize why some conflict is to be expected and why it is a part of healthy relationships</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:36.8300000' AS DateTime2), CAST(N'2023-10-21T09:29:36.8300000' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'670896f5-b0a1-413f-9c77-07e103a131c6', N'How to be Successful: Create A Growth Mindset For Success', N'how to be successful: create a growth mindset for success', N'https://img-c.udemycdn.com/course/750x422/1007674_5355_13.jpg', N'Learn to create a growth mindset that attracts success. Create & achieve your goals, learn how successful people think!', N'How to be Successful: Create A Growth Mindset For Success', N'Ongoing', 59000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Apply techniques, strategies and new perspectives to their lives, to become the most successful version of themselves</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:39.8400000' AS DateTime2), CAST(N'2023-10-21T09:29:39.8400000' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'79e5e5be-2dc2-405a-8a54-0e3124d33249', N'Learn to Sell Anything by Grant Cardone', N'learn to sell anything by grant cardone', N'https://img-b.udemycdn.com/course/750x422/619692_72d1_9.jpg', N'How to Guarantee MASSIVE Success in Sales:  A complete curriculum of sales basics, techniques, and strategies.', N'Learn to Sell Anything by Grant Cardone', N'Ongoing', 1110000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Sell your idea, service, product to anyone with confidence.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-09-29T10:29:24.0900000' AS DateTime2), CAST(N'2023-09-29T10:29:24.0900000' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'54155f7f-e41e-48f5-bcea-1181c8918c32', N'Kubernetes for the Absolute Beginners - Hands-on', N'kubernetes for the absolute beginners   hands on', N'https://img-c.udemycdn.com/course/750x422/1602900_f550_10.jpg', N'Learn Kubernetes in simple, easy and fun way with hands-on coding exercises. For beginners in DevOps.', N'Kubernetes for the Absolute Beginners - Hands-on', N'Ongoing', 63000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Gain basic understanding of Kubernetes Fundamentals</p><p>Develop Kubernetes Configuration Files in YAML</p><p>Deploy Kubernetes Cluster on local systems</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'0bd669c1-e479-4dff-a587-7035d7094973', N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-10-21T09:29:37.9100000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9100000' AS DateTime2), N'221c8992-0471-4524-b631-ca4bc6369315', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'69746c85-6109-4370-9334-1490cd2334b0', N'The Complete 2023 Web Development Bootcamp', N'the complete 2023 web development bootcamp', N'https://img-b.udemycdn.com/course/750x422/1565838_e54e_16.jpg', N'Become a Full-Stack Web Developer with just ONE course. HTML, CSS, Javascript, Node, React, MongoDB, Web3 and DApps', N'The Complete 2023 Web Development Bootcamp', N'Ongoing', 120000, 0.5, CAST(N'2023-11-11T00:00:00.0000000' AS DateTime2), N'All', N'<p>Build 16 web development projects for your portfolio, ready to apply for junior developer jobs.</p><p>Learn the latest technologies, including Javascript, React, Node and even Web3 development.</p><p>After the course you will be able to build ANY website you want.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 2, 2, 9, N'c6fa258e-4b6a-490f-ab96-a4471bebc270', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-09-23T08:55:36.3733333' AS DateTime2), CAST(N'2023-09-23T08:55:36.3733333' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'306907db-8f36-4c56-a6e5-14ad3c4979e2', N'Master the Coding Interview: Data Structures + Algorithms', N'master the coding interview: data structures   algorithms', N'https://img-c.udemycdn.com/course/750x422/1917546_682b_3.jpg', N'Ultimate coding interview bootcamp. Get more job offers, negotiate a raise: Everything you need to get the job you want!', N'Master the Coding Interview: Data Structures + Algorithms', N'Ongoing', 36000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Ace coding interviews given by some of the top tech companies</p><p>Become more confident and prepared for your next coding interview</p><p>Learn, implement, and use different Data Structures</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-10-21T09:29:35.7433333' AS DateTime2), CAST(N'2023-10-21T09:29:35.7433333' AS DateTime2), N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'fefc792a-910b-4885-8f16-1f011ed8cb19', N'The Complete Cyber Security Course : Hackers Exposed!', N'the complete cyber security course : hackers exposed ', N'https://img-c.udemycdn.com/course/750x422/614772_233b_9.jpg', N'Volume 1 : Become a Cyber Security Specialist, Learn How to Stop Hackers, Prevent Hacking,  Learn IT Security &  INFOSEC', N'The Complete Cyber Security Course : Hackers Exposed!', N'Ongoing', 71000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>An advanced practical skillset in defeating all online threats - advanced hackers, trackers, malware and all Internet nastiness including mitigating government spying and mass surveillance.</p><p>Start a career in cyber security. Become a cyber security specialist.</p><p>The very latest up-to-date information and methods.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'0bd669c1-e479-4dff-a587-7035d7094973', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:38.0766667' AS DateTime2), CAST(N'2023-10-21T09:29:38.0766667' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', N'Microsoft Power BI Desktop for Business Intelligence (2023)', N'microsoft power bi desktop for business intelligence  2023 ', N'https://img-c.udemycdn.com/course/750x422/1570206_26c6_6.jpg', N'Master Power BI Desktop for data analysis with hands-on assignments & projects from top-rated Power BI instructors', N'Microsoft Power BI Desktop for Business Intelligence (2023)', N'Ongoing', 96000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Build professional-quality business intelligence reports from the ground up</p><p>Blend and transform raw data into beautiful interactive dashboards</p><p>Design and implement the same tools used by professional analysts and data scientists</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:36.2333333' AS DateTime2), CAST(N'2023-10-21T09:29:36.2333333' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'22ab70da-adac-4aa2-b03e-2becbf29ea56', N'The Complete SQL Bootcamp: Go from Zero to Hero', N'the complete sql bootcamp: go from zero to hero', N'https://img-c.udemycdn.com/course/750x422/762616_7693_3.jpg', N'Become an expert at SQL!', N'The Complete SQL Bootcamp: Go from Zero to Hero', N'Ongoing', 81000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Use SQL to query a database</p><p>Use SQL to perform data analysis</p><p>Be comfortable putting SQL and PostgreSQL on their resume</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-10-21T09:29:36.1300000' AS DateTime2), CAST(N'2023-10-21T09:29:36.1300000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8be9c1d4-a830-4f33-8030-2dd6544fdc2e', N'Tactics for Tackling Difficult People in Life and Work', N'tactics for tackling difficult people in life and work', N'https://img-c.udemycdn.com/course/750x422/816354_ac35_2.jpg', N'Recognise and use four key skills of self-empowerment when faced with difficult behaviour', N'Tactics for Tackling Difficult People in Life and Work', N'Ongoing', 24000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Identify the most common kinds of ‘difficult’ behaviour</p><p>Recognise and use the four key skills of self-empowerment when faced with challenging behaviour</p><p>Use their listening and other skills to create an effective communications ''stance''</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:39.7533333' AS DateTime2), CAST(N'2023-10-21T09:29:39.7533333' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', N'Learn Ethical Hacking From Scratch', N'learn ethical hacking from scratch', N'https://img-c.udemycdn.com/course/750x422/857010_8239_2.jpg', N'Become an ethical hacker that can hack computer systems like black hat hackers and secure them like security experts.', N'Learn Ethical Hacking From Scratch', N'Ongoing', 62000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>135+ ethical hacking & security videos.</p><p>Start from 0 up to a high-intermediate level.</p><p>Learn ethical hacking, its fields & the different types of hackers.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'0bd669c1-e479-4dff-a587-7035d7094973', N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-10-21T09:29:37.7733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.7733333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', N'Business Analysis Fundamentals - ECBA, CCBA, CBAP endorsed', N'business analysis fundamentals   ecba  ccba  cbap endorsed', N'https://img-c.udemycdn.com/course/750x422/751792_622e_9.jpg', N'Set yourself up for success and learn the key business analysis concepts to thrive in your Business Analyst career!', N'Business Analysis Fundamentals - ECBA, CCBA, CBAP endorsed', N'Ongoing', 37000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Business Analysis basics – learn what a Business Analyst is, what they do, and how they do it</p><p>A breakdown of six project methodologies including traditional Waterfall and Agile frameworks</p><p>Learn how to properly initiate a project by creating a business case that aligns with the business objectives</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:36.5900000' AS DateTime2), CAST(N'2023-10-21T09:29:36.5900000' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', N'The Absolute Beginners Guide to Cyber Security 2023 - Part 1', N'the absolute beginners guide to cyber security 2023   part 1', N'https://img-c.udemycdn.com/course/750x422/1236568_5ada_11.jpg', N'Learn Cyber Security concepts such as hacking, malware, firewalls, worms, phishing, encryption, biometrics, BYOD & more', N'The Absolute Beginners Guide to Cyber Security 2023 - Part 1', N'Ongoing', 25000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Understand the basic concepts and terminologies used in the information and cyber security fields</p><p>Take up entry roles for IT and Cybersecurity Positions</p><p>Differentiate between the various forms of malware and how they affect computers and networks</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'0bd669c1-e479-4dff-a587-7035d7094973', N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-10-21T09:29:38.5066667' AS DateTime2), CAST(N'2023-10-21T09:29:38.5066667' AS DateTime2), N'221c8992-0471-4524-b631-ca4bc6369315', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', N'Customer Success Manager: Fundamentals to your CSM career', N'customer success manager: fundamentals to your csm career', N'https://img-b.udemycdn.com/course/750x422/703316_a5ff_5.jpg', N'The foundations to become a great Customer Success Manager in a tech company. A very well paid profession on the rise', N'Customer Success Manager: Fundamentals to your CSM career', N'Ongoing', 620000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Have a better understanding of what your job as Customer Success Manager will be like</p><p>Understand the fundamental principles of Customer Success. Which will be the foundation for your career as a CSM</p><p>Be more prepared for a Customer Success Manager job interview (we will not cover interview skills, but you will know more about customer success)</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 1, 0, 0, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-09-29T10:29:23.8766667' AS DateTime2), CAST(N'2023-09-29T10:29:23.8766667' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'00ef965c-d74e-487b-ab36-55619d89ef37', N'Java Course', N'java course', N'CourseThumb/00ef965c-d74e-487b-ab36-55619d89ef37.jpg', N'Java', N'KO', N'Ongoing', 20000, 0.6, CAST(N'2023-11-29T00:00:00.0000000' AS DateTime2), N'Beginner', N'1', N'2', 0, 0, 0, 0, N'453767b1-a798-46d5-935f-b5657c757b17', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-10-24T14:41:44.1266667' AS DateTime2), CAST(N'2023-10-24T14:41:44.1266667' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8999b164-da6b-4769-b65e-57860202e531', N'Neuro-Linguistic Programming (NLP) Practitioner Certificate', N'neuro linguistic programming  nlp  practitioner certificate', N'https://img-c.udemycdn.com/course/750x422/1336872_db4d_7.jpg', N'Gain an in-depth understanding of Neuro-Linguistic Programming (NLP) for personal growth and professional excellence.', N'Neuro-Linguistic Programming (NLP) Practitioner Certificate', N'Ongoing', 34000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>The conscious use of language – Milton & Meta model approaches.</p><p>Know how the mind works – the processes and the programming.</p><p>Take complete control of your thinking with the power of Anchoring.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'ca49669e-746e-4dab-ad77-2a625d144b8b', CAST(N'2023-10-21T09:29:39.5000000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5000000' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'dc049cd3-f74d-4e0b-b898-6258c7c89606', N'Mastering Data Structures & Algorithms using C and C++', N'mastering data structures   algorithms using c and c  ', N'https://img-c.udemycdn.com/course/750x422/2121018_9de5_5.jpg', N'Learn, Analyse and Implement Data Structure using C and C++. Learn Recursion and Sorting.', N'Mastering Data Structures & Algorithms using C and C++', N'Ongoing', 94000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Learn various Popular Data Structures and their Algorithms.</p><p>Develop your Analytical skills on Data Structure and use then efficiently.</p><p>Learn Recursive Algorithms on Data Structures</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:35.3566667' AS DateTime2), CAST(N'2023-10-21T09:29:35.3566667' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'bcb4c3e5-6e1c-4773-a925-6291222344ab', N'Build a Dropshipping Empire From Scratch [Proven Blueprint]', N'build a dropshipping empire from scratch [proven blueprint]', N'https://img-b.udemycdn.com/course/750x422/661030_70d3_7.jpg', N'Starting with just a Few Dollars Create Your Own Successful Drop Ship Business by Following the Step-by-Step System', N'Build a Dropshipping Empire From Scratch [Proven Blueprint]', N'Ongoing', 31000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Choose the right type of products to sell with the dropship model</p><p>Quickly find the right suppliers to dropship for you and know which suppliers to avoid</p><p>Set up the ''perfect'' website for drop shipping</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:37.3433333' AS DateTime2), CAST(N'2023-10-21T09:29:37.3433333' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'f77d812a-8569-4367-aaee-62ee7a1a2238', N'Complete Guide to Elasticsearch', N'complete guide to elasticsearch', N'https://img-c.udemycdn.com/course/750x422/693188_6360_3.jpg', N'Learn Elasticsearch from scratch and begin learning the ELK stack (Elasticsearch, Logstash & Kibana) and Elastic Stack.', N'Complete Guide to Elasticsearch', N'Ongoing', 94000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>How to build a powerful search engine with Elasticsearch</p><p>The theory of Elasticsearch and how it works under-the-hood</p><p>Write complex search queries</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:35.9000000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9000000' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', N'Conflict Management with Emotional Intelligence', N'conflict management with emotional intelligence', N'https://img-c.udemycdn.com/course/750x422/1173030_e426_5.jpg', N'Resolving Conflict with Emotional Intelligence | Enhancing Communication | Building Strong Relationships | Manage Stress', N'Conflict Management with Emotional Intelligence', N'Ongoing', 22000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Intermediate', N'<p>Recognize why some conflict is to be expected and why it is a part of healthy relationships.</p><p>Compare and contrast the various modes that can be used in conflict resolution.</p><p>Assess your own mode of conflict and how this helps or hinders you in working with conflict.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'ca49669e-746e-4dab-ad77-2a625d144b8b', CAST(N'2023-10-21T09:29:36.9366667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9366667' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'7393d558-f75b-4157-8e59-6ce79f779649', N'The Complete Shopify Aliexpress Dropship course', N'the complete shopify aliexpress dropship course', N'https://img-b.udemycdn.com/course/750x422/1153034_ec75_3.jpg', N'In 2023, secure your financial future, by building a highly profitable Shopify dropshipping business from home', N'The Complete Shopify Aliexpress Dropship course', N'Ongoing', 42000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>At the end of this course, you will have learnt all the skills  you need to build a PROFITABLE eCommerce store in 2023.</p><p>The course could allow you to supplement your existing income, or transform your life by giving you your very own online business to escape the 9 to 5.</p><p>You will have acquired all the essential skills to build a highly profitable dropshipping business</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-10-21T09:29:37.0566667' AS DateTime2), CAST(N'2023-10-21T09:29:37.0566667' AS DateTime2), N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', N'Linux Administration Bootcamp: Go from Beginner to Advanced', N'linux administration bootcamp: go from beginner to advanced', N'https://img-c.udemycdn.com/course/750x422/924090_507a_3.jpg', N'Learn Red Hat Linux & CentOS: Use the in-demand skills to start a career as a Linux Server Admin or Linux Administrator!', N'Linux Administration Bootcamp: Go from Beginner to Advanced', N'Ongoing', 31000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>By the end of this course you will understand the fundamentals of the Linux operating system and be able to apply that knowledge in a practical and useful manner.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-10-21T09:29:39.0200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.0200000' AS DateTime2), N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'079bf045-403c-458d-8a9f-74015888c191', N'How To Become A Shopify Expert (From Zero To Hero !)', N'how to become a shopify expert  from zero to hero   ', N'https://img-b.udemycdn.com/course/750x422/1345240_2024_3.jpg', N'In 2023, secure your financial future, and become a Shopify expert (the most in demand ecommerce platform on the planet)', N'How To Become A Shopify Expert (From Zero To Hero !)', N'Ongoing', 91000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>At the end of this course you will have an in-depth knowledge of Shopify, one of the most in-demand software solutions on the planet.</p><p>This knowledge will allow you to build a financially secure future for yourself.</p><p>The course will give you the skills to become a Shopify consultant, developer or even to create your own ecommerce business.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-10-21T09:29:37.6200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.6200000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', N'Build Responsive Real-World Websites with HTML and CSS', N'build responsive real world websites with html and css', N'https://img-b.udemycdn.com/course/750x422/437398_46c3_10.jpg', N'Learn modern HTML5, CSS3 and web design by building a stunning website for your portfolio! Includes flexbox and CSS Grid', N'Build Responsive Real-World Websites with HTML and CSS', N'Ongoing', 2140000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Become a modern and confident HTML and CSS developer, no prior knowledge needed!</p><p>Design and build a stunning real-world project for your portfolio from scratch</p><p>Modern, semantic and accessible HTML5</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'c6fa258e-4b6a-490f-ab96-a4471bebc270', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'cfb0e398-5f54-4793-b1e2-87955920c6dc', N'Learn Linux in 5 Days and Level Up Your Career', N'learn linux in 5 days and level up your career', N'https://img-c.udemycdn.com/course/750x422/256758_e35d_5.jpg', N'Use the in-demand Linux skills you learn in this course to get promoted or start a new career as a Linux professional.', N'Learn Linux in 5 Days and Level Up Your Career', N'Ongoing', 82000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>By the end of this course you will understand the fundamentals of the Linux operating system and be able to apply that knowledge in a practical and useful manner.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:38.6133333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6133333' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', N'Linux for Beginners', N'linux for beginners', N'https://img-c.udemycdn.com/course/750x422/149910_25f7_7.jpg', N'An Introduction to the Linux Operating System and Command Line', N'Linux for Beginners', N'Ongoing', 37000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>By the end of this course you will understand the fundamentals of the Linux operating system and be able to apply that knowledge in a practical and useful manner.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-10-21T09:29:39.2866667' AS DateTime2), CAST(N'2023-10-21T09:29:39.2866667' AS DateTime2), N'221c8992-0471-4524-b631-ca4bc6369315', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', N'Business Development & B2B Sales for Startups- Sales Valley', N'business development   b2b sales for startups  sales valley', N'https://img-b.udemycdn.com/course/750x422/1449746_ca17_2.jpg', N'The Complete Startup Playbook for Business Development & B2B Sales to learn Lead Generation, Pitching, & Closing Deals.', N'Business Development & B2B Sales for Startups- Sales Valley', N'Ongoing', 880000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Students will learn the PROVEN Sales Valley Methodology to build business relationships and generate sales</p><p>How to sell and generate meetings remotely and be productive while working from home</p><p>All the different types of business development deal structures you can use to grow your business</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-09-29T10:29:23.4300000' AS DateTime2), CAST(N'2023-09-29T10:29:23.4300000' AS DateTime2), N'221c8992-0471-4524-b631-ca4bc6369315', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', N'Life Coaching Certificate Course (Beginner to Intermediate)', N'life coaching certificate course  beginner to intermediate ', N'https://img-c.udemycdn.com/course/750x422/1080376_3647_10.jpg', N'A comprehensive online training that delivers in-depth understanding of the key elements of the Life Coaching profession', N'Life Coaching Certificate Course (Beginner to Intermediate)', N'Ongoing', 33000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>A time-proven life coaching methodology that’s been practiced on 2000+ people.</p><p>Develop an enhanced sense of social awareness and improve your people skills.</p><p>Lead people into heightened states of innovation, creativity and personal effectiveness.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-10-21T09:29:39.3966667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3966667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', N'Complete Linux Training Course to Get Your Dream IT Job 2023', N'complete linux training course to get your dream it job 2023', N'https://img-c.udemycdn.com/course/750x422/1523066_334c_14.jpg', N'The BEST Linux Administration course that prepares you for corporate jobs and for RHCSA, RHCE, LFCS, CLNP certifications', N'Complete Linux Training Course to Get Your Dream IT Job 2023', N'Ongoing', 97000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>By the end of this course you will be a professional Linux administrator and be able to apply for Linux jobs</p><p>You will be able to take the EX-200 exam and become Redhat Certified System Administrator (RHCSA - EX200)</p><p>You will learn 200+ Linux system administration commands</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:38.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.7200000' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8e4a122d-62fa-43c2-b2c2-a58053447f33', N'SQL - MySQL for Data Analytics and Business Intelligence', N'sql   mysql for data analytics and business intelligence', N'https://img-c.udemycdn.com/course/750x422/1405632_6e6f_2.jpg', N'SQL that will get you hired – SQL for Business Analysis, Marketing, and Data Management', N'SQL - MySQL for Data Analytics and Business Intelligence', N'Ongoing', 84000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Become an expert in SQL</p><p>Learn how to code in SQL</p><p>Boost your resume by learning an in-demand skill</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:36.4933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.4933333' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'9fed7922-71ef-404b-b105-a58c9d8a8c12', N'ChatGPT Masterclass: ChatGPT Guide for Beginners to Experts!', N'chatgpt masterclass: chatgpt guide for beginners to experts ', N'https://img-b.udemycdn.com/course/750x422/5055656_31a8_3.jpg', N'ChatGPT Profit Playbook: Skyrocket your Online Earnings with AI Tools | ChatGPT Implementation, Plugins, Content Mastery', N'ChatGPT Masterclass: ChatGPT Guide for Beginners to Experts!', N'Ongoing', 92000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>How to create SEO, E-commerce, translation, Amazon, and sales-copy using ChatGPT</p><p>How to give ChatGPT access current information and bypass limits on indexed information</p><p>How to quickly craft  podcasts and other long-form content using ChatGPT</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'e307a3a8-5c1d-46f7-bcb7-7e1389efccf3', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:37.4866667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4866667' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'eb218df6-0f81-40a0-890b-aacff717e76d', N'SOLID Principles: Introducing Software Architecture & Design', N'solid principles: introducing software architecture   design', N'https://img-c.udemycdn.com/course/750x422/2521572_c415_9.jpg', N'Gain mastery over SOLID Principles and write clean and well-designed code in Object Oriented Languages like Java etc.', N'SOLID Principles: Introducing Software Architecture & Design', N'Ongoing', 33000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Anyone can code, but quality code is hard to come by. Make yourself stand out by learning how to write quality code.</p><p>Learn basic software architecture by applying SOLID principles.</p><p>Apply SOLID principles in order to write quality code, as a software engineer.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'bcd54261-1d15-4fde-9d29-3bbdb45b03c8', N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-10-21T09:29:36.0333333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0333333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'af36ec51-e721-4945-a73b-ab1e8765c619', N'Customer Service Mastery: Delight Every Customer', N'customer service mastery: delight every customer', N'https://img-b.udemycdn.com/course/750x422/1919728_cf04_6.jpg', N'Master Customer Service using this practical customer care course', N'Customer Service Mastery: Delight Every Customer', N'Ongoing', 1350000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Be flooded with ideas on how to delight customers</p><p>Stand out from competitors with unique customer experiences</p><p>Create customers who are loyal for life and sing your praises to friends and family</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-09-29T10:29:23.1233333' AS DateTime2), CAST(N'2023-09-29T10:29:23.1233333' AS DateTime2), N'221c8992-0471-4524-b631-ca4bc6369315', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'9b774995-5f60-4317-80ac-ad4e0730a2ed', N'Angular - The Complete Guide (2023 Edition)', N'angular   the complete guide  2023 edition ', N'https://img-b.udemycdn.com/course/750x422/756150_c033_2.jpg', N'Master Angular (formerly "Angular 2") and build awesome, reactive web apps with the successor of Angular.js', N'Angular - The Complete Guide (2023 Edition)', N'Ongoing', 880000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Develop modern, complex, responsive and scalable web applications with Angular</p><p>Fully understand the architecture behind an Angular application and how to use it</p><p>Use the gained, deep understanding of the Angular fundamentals to quickly establish yourself as a frontend developer</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'c6fa258e-4b6a-490f-ab96-a4471bebc270', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'c538b99b-f724-4788-879f-adfe3b1a90ea', N'Title', N'title', N'https://img-b.udemycdn.com/course/750x422/756150_c033_2.jpg', N'Intro', N'Description', N'0', 20000, 0, CAST(N'2003-10-10T00:00:00.0000000' AS DateTime2), N'1', N'Outcomes 12', N'Requirements 12345', 0, 1, 0, 0, N'd78b5017-1dac-4295-ba74-01a20b245ab6', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-09-26T15:45:22.5366667' AS DateTime2), CAST(N'2023-09-26T15:45:22.5366667' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'39dcb58a-5a86-4220-8366-518be3efe406')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'7f1e0959-2530-4367-941e-ae1b1e99bdc1', N'Sexual Harassment Training for Employees in the Workplace', N'sexual harassment training for employees in the workplace', N'https://img-c.udemycdn.com/course/750x422/1820254_abe4.jpg', N'Learn about sexual harassment in the workplace and the ways to identify, report, and prevent it.', N'Sexual Harassment Training for Employees in the Workplace', N'Ongoing', 72000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Identify and prevent sexual harassment in the workplace</p><p>Ensure that employees are aware of their compliance responsibilities</p><p>Protect the organization''s reputation</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:36.9566667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9566667' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', N'Microsoft Power BI - The Practical Guide 2023', N'microsoft power bi   the practical guide 2023', N'https://img-c.udemycdn.com/course/750x422/1208634_cd50_2.jpg', N'Dive in and learn the Power BI tools! Learn Data Analysis & Visualization and more in Power BI Desktop & Power BI Pro!', N'Microsoft Power BI - The Practical Guide 2023', N'Ongoing', 77000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>At the end of this course students will be able to analyse data from different data sources and create their own datasets</p><p>Students will be able to comfortably work with the different tools of the Power BI universe and know how the different tools work together</p><p>Students will have the required knowledge to dive deeper into Power BI and find out more about its advanced features</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', N'Linux Mastery: Master the Linux Command Line in 11.5 Hours', N'linux mastery: master the linux command line in 11 5 hours', N'https://img-c.udemycdn.com/course/750x422/1320362_1b73_7.jpg', N'Learn the Linux Command Line from Scratch and Improve your Career with the World''s Most Fun Project-Based Linux Course!', N'Linux Mastery: Master the Linux Command Line in 11.5 Hours', N'Ongoing', 96000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'Beginner', N'<p>Quickly Learn the Linux Command Line from Scratch!</p><p>Use Bash Scripts and Cron Scheduling Software to Automate Boring Tasks!</p><p>Become an Independent User of the Linux Operating System!</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-10-21T09:29:39.1166667' AS DateTime2), CAST(N'2023-10-21T09:29:39.1166667' AS DateTime2), N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', N'Unconscious Bias: Fuel Diversity and Become a Better You', N'unconscious bias: fuel diversity and become a better you', N'https://img-c.udemycdn.com/course/750x422/2412206_cba1_4.jpg', N'Defeat unconscious bias and build diversity and inclusion into your life even if it seems impossible right now!', N'Unconscious Bias: Fuel Diversity and Become a Better You', N'Ongoing', 22000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Why our brains make the mental shortcuts that become our unconscious biases</p><p>Several sneaky unconscious biases that wreak havoc on every decision in life</p><p>A powerful way to grow your self awareness to reveal your hidden biases</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'6fff40b6-f7e1-4cb8-9bea-50bc44015ecc', N'ca49669e-746e-4dab-ad77-2a625d144b8b', CAST(N'2023-10-21T09:29:36.7333333' AS DateTime2), CAST(N'2023-10-21T09:29:36.7333333' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'c144e470-4447-4ae7-8878-c6059a24888b', N'Tableau 2022 A-Z: Hands-On Tableau Training for Data Science', N'tableau 2022 a z: hands on tableau training for data science', N'https://img-c.udemycdn.com/course/750x422/937678_abd2_3.jpg', N'Learn Tableau 2022 for data science step by step. Real-life data analytics exercises & quizzes included. Learn by doing!', N'Tableau 2022 A-Z: Hands-On Tableau Training for Data Science', N'Ongoing', 67000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Install Tableau Desktop 2022</p><p>Connect Tableau to various Datasets: Excel and CSV files</p><p>Create Barcharts</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'b09ef2e9-f0ef-47b2-8c18-f11b4f690af9', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:36.3500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.3500000' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', N'The Web Developer Bootcamp 2023', N'the web developer bootcamp 2023', N'https://img-b.udemycdn.com/course/750x422/625204_436a_3.jpg', N'10 Hours of React just added. Become a Developer With ONE course - HTML, CSS, JavaScript, React, Node, MongoDB and More!', N'The Web Developer Bootcamp 2023', N'Ongoing', 1550000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>The ins and outs of HTML5, CSS3, and Modern JavaScript for 2021</p><p>Make REAL web applications using cutting-edge technologies</p><p>Create responsive, accessible, and beautiful layouts</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'c6fa258e-4b6a-490f-ab96-a4471bebc270', N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'd58c5d69-6b8c-4889-a225-dd2295000787', N'Linux Command Line Basics', N'linux command line basics', N'https://img-c.udemycdn.com/course/750x422/95246_69f4_23.jpg', N'This is an introductory course to the Linux command Line. It''s great for both Linux beginners and advanced Linux users.', N'Linux Command Line Basics', N'Ongoing', 66000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>realize the potential of the Linux command line.</p><p>navigating the Linux Filesystem.</p><p>explain the Linux Filesystem hierarchy.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'a7131eda-d6e8-4209-89c2-ba5f257a29bb', N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-10-21T09:29:38.8900000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8900000' AS DateTime2), N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', N'Professional Life Coach Certification & Guide (Accredited)', N'professional life coach certification   guide  accredited ', N'https://img-c.udemycdn.com/course/750x422/789146_6b10_4.jpg', N'Become a certified life coach & grow your life coaching business! Done-for-you forms, tools, processes & best practices', N'Professional Life Coach Certification & Guide (Accredited)', N'Ongoing', 33000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Feel confident in your ability to get your clients real results.</p><p>Feel credible and prepared.</p><p>Structure your coaching business, including packages, sessions and your ideal coaching niche.</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'75fef7cb-e841-493c-a999-b9b2cd3c970a', N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-10-21T09:29:39.6200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6200000' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Courses] ([Id], [Title], [MetaTitle], [ThumbUrl], [Intro], [Description], [Status], [Price], [Discount], [DiscountExpiry], [Level], [Outcomes], [Requirements], [LectureCount], [LearnerCount], [RatingCount], [TotalRating], [LeafCategoryId], [InstructorId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'b14177f1-c33a-46e4-b772-f65fada8a6b1', N'Sales Training: Practical Sales Techniques', N'sales training: practical sales techniques', N'https://img-b.udemycdn.com/course/750x422/563478_2c35.jpg', N'Sales Hacking: Essential sales skills, sales strategies and sales techniques to sell just about anything!', N'Sales Training: Practical Sales Techniques', N'Ongoing', 1130000, 0, CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), N'All', N'<p>Enjoy selling by befriending customers</p><p>Close deals with confidence</p><p>Be organised and efficient</p>', N'<p>I''ll teach you everything you need to know</p><p>A computer with access to the internet</p>', 0, 0, 0, 0, N'7c9a5690-a5d6-4455-b8ac-ad60b58919b3', N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-09-29T10:29:22.7233333' AS DateTime2), CAST(N'2023-09-29T10:29:22.7233333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
GO
INSERT [dbo].[Enrollments] ([CreatorId], [CourseId], [Status], [BillId], [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]) VALUES (N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'c538b99b-f724-4788-879f-adfe3b1a90ea', N'Completed', N'8378fe89-da94-406d-b0f3-f9784b5b6185', CAST(N'2023-10-20T22:04:24.9566667' AS DateTime2), N'["77d68364-fbd5-43dd-8720-926da682b0d7","bc104e6c-eec8-4dcd-b476-c34b2336bfb3","7d55216c-dcd4-4013-8461-f1aac771417b"]', N'', N'')
INSERT [dbo].[Enrollments] ([CreatorId], [CourseId], [Status], [BillId], [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'69746c85-6109-4370-9334-1490cd2334b0', N'Ongoing', N'515ae820-4d3f-4d0f-a33e-3ef4d1396306', CAST(N'2023-09-29T22:01:16.3600000' AS DateTime2), N'["bf0bb2bb-0bfb-408c-a9f5-f263eb811288","215adbdd-0b6d-40a5-95f1-effe85229b9e"]', N'', N'')
INSERT [dbo].[Enrollments] ([CreatorId], [CourseId], [Status], [BillId], [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]) VALUES (N'603d925c-147c-4d22-82cf-23633d1c4a80', N'76bf19f6-1221-4242-97bb-0355035a3389', N'Ongoing', N'a138a1c0-6c56-4d58-8ee7-6d3e8d653e93', CAST(N'2023-10-19T21:14:36.8700000' AS DateTime2), N'', N'', N'')
INSERT [dbo].[Enrollments] ([CreatorId], [CourseId], [Status], [BillId], [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]) VALUES (N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'69746c85-6109-4370-9334-1490cd2334b0', N'Ongoing', N'dd29609d-9656-4173-92c2-d44401cb29cb', CAST(N'2023-10-06T13:48:59.7400000' AS DateTime2), N'', N'', N'')
INSERT [dbo].[Enrollments] ([CreatorId], [CourseId], [Status], [BillId], [CreationTime], [AssignmentMilestones], [LectureMilestones], [SectionMilestones]) VALUES (N'bda2a548-450a-402e-a75a-9712bcc6fc31', N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', N'Ongoing', N'bf31bd88-83b8-4c32-8465-98fb778b987a', CAST(N'2023-10-06T14:31:35.5833333' AS DateTime2), N'', N'', N'')
GO
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'ca49669e-746e-4dab-ad77-2a625d144b8b', N'Watashi wa DangHang', N'Watashi wa DangHang 123456', N'603d925c-147c-4d22-82cf-23633d1c4a80', CAST(N'2023-10-19T22:01:03.2133333' AS DateTime2), CAST(N'2023-10-19T22:01:03.2133333' AS DateTime2), 0, 3)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', N'I am Hồ Hoàng Lộc', N'I am Hồ Hoàng Lộc, an instructor', N'39dcb58a-5a86-4220-8366-518be3efe406', CAST(N'2023-09-23T08:54:57.5600000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 2000000, 11)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', N'I am HuynhGiang59 #4', N'I am HuynhGiang59 #5', N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', CAST(N'2023-09-27T13:12:24.8800000' AS DateTime2), CAST(N'2023-09-27T13:12:24.8800000' AS DateTime2), 0, 5)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', N'', N'', N'221c8992-0471-4524-b631-ca4bc6369315', CAST(N'2023-09-23T08:54:57.5566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 0, 5)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'999f009d-e6ad-4b6a-91b2-964af68c65db', N'My Intro 123456', N'My Exp 123', N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', CAST(N'2023-09-23T08:54:57.5533333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 0, 5)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'337c40b6-457c-4b7a-81f5-af9934ce46b5', N'My Intro Ngo Hoai Quynh', N'My Exp Ngo Hoai Quynh', N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', CAST(N'2023-09-23T08:54:57.3633333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 65000000, 6)
INSERT [dbo].[Instructors] ([Id], [Intro], [Experience], [CreatorId], [CreationTime], [LastModificationTime], [Balance], [CourseCount]) VALUES (N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', N'', N'', N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', CAST(N'2023-09-23T08:54:57.5600000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 62000000, 10)
GO
SET IDENTITY_INSERT [dbo].[LectureMaterial] ON 

INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'0f9acec4-3fe3-4c23-cc27-08dbbbda1458', 3, N'Video', N'CourseMedia/69746c85-6109-4370-9334-1490cd2334b0/ce7c409d-a615-4336-b430-8c5bd17d927c.mp4')
INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'0f9acec4-3fe3-4c23-cc27-08dbbbda1458', 4, N'Document', N'CourseMedia/69746c85-6109-4370-9334-1490cd2334b0/af63abf1-ae38-4f58-86ba-500042c72e23.jpg')
INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'b494d1f9-7861-49fa-cc28-08dbbbda1458', 5, N'Document', N'CourseMedia/69746c85-6109-4370-9334-1490cd2334b0/accca829-a88d-46e0-a030-660efa68b37b.png')
INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'b494d1f9-7861-49fa-cc28-08dbbbda1458', 6, N'Document', N'CourseMedia/69746c85-6109-4370-9334-1490cd2334b0/247e6b51-dd19-4136-ab92-4752572a39fa.jpg')
INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'c374bebd-5b47-4241-eedd-08dbd1e9b6c3', 7, N'Video', N'CourseMedia/da90cb50-fd9a-490a-bf29-bc0aae901cc5/bfbc058a-96f4-4420-89b6-e0b630a46eca.mp4')
INSERT [dbo].[LectureMaterial] ([LectureId], [Id], [Type], [Url]) VALUES (N'aa30c09e-c867-42f8-5e84-08dbd1ed43c2', 8, N'Video', N'CourseMedia/da90cb50-fd9a-490a-bf29-bc0aae901cc5/04c29984-91a0-4120-84eb-3f8d9c38e4e3.mp4')
SET IDENTITY_INSERT [dbo].[LectureMaterial] OFF
GO
INSERT [dbo].[Lectures] ([Id], [Title], [Content], [SectionId], [CreationTime], [LastModificationTime], [IsPreviewable]) VALUES (N'0f9acec4-3fe3-4c23-cc27-08dbbbda1458', N'Title 1', N'Content 1', N'484275b5-e6f3-4ccc-6089-08dbbbd82e06', CAST(N'2023-09-23T09:09:12.9900000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 0)
INSERT [dbo].[Lectures] ([Id], [Title], [Content], [SectionId], [CreationTime], [LastModificationTime], [IsPreviewable]) VALUES (N'b494d1f9-7861-49fa-cc28-08dbbbda1458', N'Title 2', N'Content 2', N'484275b5-e6f3-4ccc-6089-08dbbbd82e06', CAST(N'2023-09-23T09:11:29.0533333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2), 0)
INSERT [dbo].[Lectures] ([Id], [Title], [Content], [SectionId], [CreationTime], [LastModificationTime], [IsPreviewable]) VALUES (N'c374bebd-5b47-4241-eedd-08dbd1e9b6c3', N'How to Program in C', N'How to Program in C', N'a9024270-a55c-4501-50bf-08dbd1dd90e7', CAST(N'2023-10-21T10:56:33.8400000' AS DateTime2), CAST(N'2023-10-21T10:56:33.8400000' AS DateTime2), 0)
INSERT [dbo].[Lectures] ([Id], [Title], [Content], [SectionId], [CreationTime], [LastModificationTime], [IsPreviewable]) VALUES (N'aa30c09e-c867-42f8-5e84-08dbd1ed43c2', N'Conclusion', N'Conclusion', N'c9bf484f-8444-485c-50c5-08dbd1dd90e7', CAST(N'2023-10-21T11:21:58.8100000' AS DateTime2), CAST(N'2023-10-21T11:21:58.8100000' AS DateTime2), 0)
GO
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'dea345a3-833b-4a89-f6ba-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2a4b93d6-eb07-4e77-70f0-08dbc4bcacbd', N'American Sniper', 0, N'dea345a3-833b-4a89-f6ba-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2569f1cc-0e67-4b03-70f1-08dbc4bcacbd', N'Boyhood', 0, N'dea345a3-833b-4a89-f6ba-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e528bfc2-ff43-4983-70f2-08dbc4bcacbd', N'The Grand Budapest Hotel', 0, N'dea345a3-833b-4a89-f6ba-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'5a0c33c5-f7ac-49e3-f6bb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e6a0971a-e283-4865-70f4-08dbc4bcacbd', N'That is so fetch.', 0, N'5a0c33c5-f7ac-49e3-f6bb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ed41969d-4fc4-4bcb-70f5-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'5a0c33c5-f7ac-49e3-f6bb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4c40993e-b842-43cb-70f6-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'5a0c33c5-f7ac-49e3-f6bb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'30ac48ad-3441-4825-70f7-08dbc4bcacbd', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'3d102481-515b-49a1-f6bc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'899c0c0c-7a21-41a2-70f8-08dbc4bcacbd', N'American Sniper', 0, N'3d102481-515b-49a1-f6bc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c8d7c3c0-268a-4bf3-70f9-08dbc4bcacbd', N'Boyhood', 0, N'3d102481-515b-49a1-f6bc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'42f1b293-d52a-4517-70fa-08dbc4bcacbd', N'The Grand Budapest Hotel', 0, N'3d102481-515b-49a1-f6bc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'25f94752-856c-4477-70fb-08dbc4bcacbd', N'The Two Towers', 1, N'8caa9bad-bbb6-454c-f6bd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a3ac3502-aae1-400b-70fc-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'8caa9bad-bbb6-454c-f6bd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'14e7e8b4-5796-4ea9-70fd-08dbc4bcacbd', N'The Mysterious Island', 0, N'8caa9bad-bbb6-454c-f6bd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e5f46149-f67f-4596-70fe-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'8caa9bad-bbb6-454c-f6bd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'28d63dfa-4dae-4a0a-70ff-08dbc4bcacbd', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'43f8f7e6-bb79-46cc-f6be-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a71a2527-6721-4c23-7100-08dbc4bcacbd', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'43f8f7e6-bb79-46cc-f6be-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'baacb809-60fd-4be8-7101-08dbc4bcacbd', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'43f8f7e6-bb79-46cc-f6be-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'75297694-28ae-441b-7102-08dbc4bcacbd', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'43f8f7e6-bb79-46cc-f6be-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2ab7179c-5ebd-4b9a-7103-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'864762d3-fe68-4f20-f6bf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'cc990d63-7c84-426c-7104-08dbc4bcacbd', N'That is so fetch.', 0, N'864762d3-fe68-4f20-f6bf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'094c945d-2a7a-42ff-7105-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'864762d3-fe68-4f20-f6bf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'398c800f-0e80-4e21-7106-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'864762d3-fe68-4f20-f6bf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b0dba081-9011-4d29-7107-08dbc4bcacbd', N'The Two Towers', 1, N'388f6369-163d-4d9a-f6c0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e05345a2-c7ee-44da-7108-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'388f6369-163d-4d9a-f6c0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f02f0d66-e985-47f2-7109-08dbc4bcacbd', N'The Mysterious Island', 0, N'388f6369-163d-4d9a-f6c0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd01effa4-0e14-4cad-710a-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'388f6369-163d-4d9a-f6c0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'dfaf5dc3-91b3-46ca-710b-08dbc4bcacbd', N'Russell Crowe', 1, N'375c0a1c-649c-4401-f6c1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c9c2cc79-e2ce-48c7-710c-08dbc4bcacbd', N'Tom Hanks', 0, N'375c0a1c-649c-4401-f6c1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'165d1a0d-553e-4c0b-710d-08dbc4bcacbd', N'Ed Harris', 0, N'375c0a1c-649c-4401-f6c1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'5463e672-538b-4471-710e-08dbc4bcacbd', N'Javier Bardem', 0, N'375c0a1c-649c-4401-f6c1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'64238f41-3a20-4f4b-710f-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'9a93881f-8afe-41ad-f6c2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f6838c9e-fefa-46c4-7110-08dbc4bcacbd', N'That is so fetch.', 0, N'9a93881f-8afe-41ad-f6c2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ed057374-4d23-4266-7111-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'9a93881f-8afe-41ad-f6c2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b686b99d-f053-4c05-7112-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'9a93881f-8afe-41ad-f6c2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd4519eb8-fd03-4c5c-7113-08dbc4bcacbd', N'The Two Towers', 1, N'84a46d31-37ad-4dca-f6c3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a0a78c51-4819-4208-7114-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'84a46d31-37ad-4dca-f6c3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'09667ef2-0e94-43fd-7115-08dbc4bcacbd', N'The Mysterious Island', 0, N'84a46d31-37ad-4dca-f6c3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'8802f729-a0fd-4b20-7116-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'84a46d31-37ad-4dca-f6c3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'9652c0ca-d380-4904-7117-08dbc4bcacbd', N'The Graduate', 1, N'2cc3988c-cbd9-41da-f6c4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'414f0c6b-09f2-4c0f-7118-08dbc4bcacbd', N'Mad Max', 0, N'2cc3988c-cbd9-41da-f6c4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4a2cd26b-e679-450f-7119-08dbc4bcacbd', N'One Flew Over the Cuckoo''s Nest', 0, N'2cc3988c-cbd9-41da-f6c4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e38ec1a2-445b-4252-711a-08dbc4bcacbd', N'The Night of the Hunter', 0, N'2cc3988c-cbd9-41da-f6c4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4f47b696-a0cb-46aa-711b-08dbc4bcacbd', N'Russell Crowe', 1, N'091f0f04-a3e9-4976-f6c5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'008673fd-1203-40a0-711c-08dbc4bcacbd', N'Tom Hanks', 0, N'091f0f04-a3e9-4976-f6c5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'16b5dff2-5bfd-4998-711d-08dbc4bcacbd', N'Ed Harris', 0, N'091f0f04-a3e9-4976-f6c5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4532d98f-3785-4a12-711e-08dbc4bcacbd', N'Javier Bardem', 0, N'091f0f04-a3e9-4976-f6c5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b32a445c-a96a-4f2f-711f-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'd196edfb-5b24-4ef9-f6c6-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b1bfd9f5-381a-44c9-7120-08dbc4bcacbd', N'That is so fetch.', 0, N'd196edfb-5b24-4ef9-f6c6-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2e5e0efc-743a-4b83-7121-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'd196edfb-5b24-4ef9-f6c6-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'fb834f94-1e6d-435d-7122-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'd196edfb-5b24-4ef9-f6c6-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4d550efb-89c3-4805-7123-08dbc4bcacbd', N'The Two Towers', 1, N'008bbd19-c950-4b1b-f6c7-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c2d2a6bc-7bf6-4398-7124-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'008bbd19-c950-4b1b-f6c7-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e8b133c0-151e-436c-7125-08dbc4bcacbd', N'The Mysterious Island', 0, N'008bbd19-c950-4b1b-f6c7-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'7e55c297-27f6-4bfb-7126-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'008bbd19-c950-4b1b-f6c7-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c4744ae7-8340-4aac-7127-08dbc4bcacbd', N'The Graduate', 1, N'01286087-ffcf-4a90-f6c8-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'49faa35b-c18a-4e63-7128-08dbc4bcacbd', N'Mad Max', 0, N'01286087-ffcf-4a90-f6c8-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'34e225db-3954-4da5-7129-08dbc4bcacbd', N'One Flew Over the Cuckoo''s Nest', 0, N'01286087-ffcf-4a90-f6c8-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'99ad7632-e3ac-4e0b-712a-08dbc4bcacbd', N'The Night of the Hunter', 0, N'01286087-ffcf-4a90-f6c8-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'1e506492-91b8-4398-712b-08dbc4bcacbd', N'Russell Crowe', 1, N'efc656a5-5ba3-4863-f6c9-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6989246d-c26c-40a9-712c-08dbc4bcacbd', N'Tom Hanks', 0, N'efc656a5-5ba3-4863-f6c9-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'29a13c63-8cf4-473c-712d-08dbc4bcacbd', N'Ed Harris', 0, N'efc656a5-5ba3-4863-f6c9-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'36b6c407-4478-4c8b-712e-08dbc4bcacbd', N'Javier Bardem', 0, N'efc656a5-5ba3-4863-f6c9-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'857c9a9d-1453-49b7-712f-08dbc4bcacbd', N'The Graduate', 1, N'd2319f15-de1d-4b57-f6ca-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c1c3546c-54e0-4468-7130-08dbc4bcacbd', N'Mad Max', 0, N'd2319f15-de1d-4b57-f6ca-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'7b7a3bc2-38e0-453a-7131-08dbc4bcacbd', N'One Flew Over the Cuckoo''s Nest', 0, N'd2319f15-de1d-4b57-f6ca-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e08d406b-6021-4092-7132-08dbc4bcacbd', N'The Night of the Hunter', 0, N'd2319f15-de1d-4b57-f6ca-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'005835f1-2a09-4a49-7133-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'920841fe-97bf-4767-f6cb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'518ec14a-e37e-4aad-7134-08dbc4bcacbd', N'That is so fetch.', 0, N'920841fe-97bf-4767-f6cb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd07be971-70e7-4e0a-7135-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'920841fe-97bf-4767-f6cb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'da26c961-8eb8-4dd3-7136-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'920841fe-97bf-4767-f6cb-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b621e7aa-7bb1-47ae-7137-08dbc4bcacbd', N'The Two Towers', 1, N'6c1c2532-5c18-4b81-f6cc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c1d2d1e2-6321-42b5-7138-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'6c1c2532-5c18-4b81-f6cc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'9137fe99-3db9-4142-7139-08dbc4bcacbd', N'The Mysterious Island', 0, N'6c1c2532-5c18-4b81-f6cc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'af2e6c4e-8cd4-40f3-713a-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'6c1c2532-5c18-4b81-f6cc-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b1538954-98eb-491f-713b-08dbc4bcacbd', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'9fce4151-9ae2-4f42-f6cd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'5bb82078-5ae4-4be0-713c-08dbc4bcacbd', N'American Sniper', 0, N'9fce4151-9ae2-4f42-f6cd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd538d574-1002-4675-713d-08dbc4bcacbd', N'Boyhood', 0, N'9fce4151-9ae2-4f42-f6cd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4dc60dd4-c4f3-4103-713e-08dbc4bcacbd', N'The Grand Budapest Hotel', 0, N'9fce4151-9ae2-4f42-f6cd-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'93c1d645-f1c5-42a0-713f-08dbc4bcacbd', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'8deabef4-553a-4a36-f6ce-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'9514199a-1bc7-4b11-7140-08dbc4bcacbd', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'8deabef4-553a-4a36-f6ce-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'29972be1-44fa-476d-7141-08dbc4bcacbd', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'8deabef4-553a-4a36-f6ce-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b1098ecd-9a3b-4a48-7142-08dbc4bcacbd', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'8deabef4-553a-4a36-f6ce-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c1255511-964a-4e9f-7143-08dbc4bcacbd', N'The Graduate', 1, N'ab878ae7-4144-48aa-f6cf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'5fbb3fe9-2828-465b-7144-08dbc4bcacbd', N'Mad Max', 0, N'ab878ae7-4144-48aa-f6cf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f81df328-8067-4aa1-7145-08dbc4bcacbd', N'One Flew Over the Cuckoo''s Nest', 0, N'ab878ae7-4144-48aa-f6cf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'24d35b12-044c-48ae-7146-08dbc4bcacbd', N'The Night of the Hunter', 0, N'ab878ae7-4144-48aa-f6cf-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'bf99544d-d09b-4d94-7147-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'b84665e4-d31b-442e-f6d0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'7bc43449-e0ea-4baa-7148-08dbc4bcacbd', N'That is so fetch.', 0, N'b84665e4-d31b-442e-f6d0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f9db1722-33f8-4058-7149-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'b84665e4-d31b-442e-f6d0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c2157843-368f-43a1-714a-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'b84665e4-d31b-442e-f6d0-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b89a77ba-5dc2-4ca2-714b-08dbc4bcacbd', N'The Graduate', 1, N'0fcc5814-cc32-4f14-f6d1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'178201c7-8eb3-4828-714c-08dbc4bcacbd', N'Mad Max', 0, N'0fcc5814-cc32-4f14-f6d1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c86fa640-3386-419c-714d-08dbc4bcacbd', N'One Flew Over the Cuckoo''s Nest', 0, N'0fcc5814-cc32-4f14-f6d1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'338be600-392d-4cf9-714e-08dbc4bcacbd', N'The Night of the Hunter', 0, N'0fcc5814-cc32-4f14-f6d1-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'8e1e9a3a-655c-4449-714f-08dbc4bcacbd', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'dad1c6ef-8834-4913-f6d2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd574f651-d2e3-4df9-7150-08dbc4bcacbd', N'American Sniper', 0, N'dad1c6ef-8834-4913-f6d2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'182c631d-4247-4cee-7151-08dbc4bcacbd', N'Boyhood', 0, N'dad1c6ef-8834-4913-f6d2-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'58a7bdf0-ccd9-4209-7152-08dbc4bcacbd', N'The Grand Budapest Hotel', 0, N'dad1c6ef-8834-4913-f6d2-08dbc4bcacb8')
GO
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'555bd91b-e8d7-414a-7153-08dbc4bcacbd', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'edcf8d15-82c1-4e15-f6d3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b1e13b85-37fe-458a-7154-08dbc4bcacbd', N'That is so fetch.', 0, N'edcf8d15-82c1-4e15-f6d3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd4d920e1-21e3-4a59-7155-08dbc4bcacbd', N'I am big! It''s the pictures that got small.', 0, N'edcf8d15-82c1-4e15-f6d3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'751258bd-0ae7-4474-7156-08dbc4bcacbd', N'Mother of mercy, is this the end of Rico?', 0, N'edcf8d15-82c1-4e15-f6d3-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f11f5921-822d-492b-7157-08dbc4bcacbd', N'The Two Towers', 1, N'16cafee7-cc0b-48c8-f6d4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'7f91f0ab-11f7-4c3b-7158-08dbc4bcacbd', N'Life, the Universe and Everything', 0, N'16cafee7-cc0b-48c8-f6d4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'03e37fd4-f96f-41c4-7159-08dbc4bcacbd', N'The Mysterious Island', 0, N'16cafee7-cc0b-48c8-f6d4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'141a25a5-da82-42ce-715a-08dbc4bcacbd', N'A Connecticut Yankee in King Arthur''s Court', 0, N'16cafee7-cc0b-48c8-f6d4-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'242c6f2f-d5d2-461f-715b-08dbc4bcacbd', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'535b17fc-6695-46c8-f6d5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a4e96e50-3eb0-43a7-715c-08dbc4bcacbd', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'535b17fc-6695-46c8-f6d5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'01151ded-c7fc-4c56-715d-08dbc4bcacbd', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'535b17fc-6695-46c8-f6d5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6daa44c1-640a-424d-715e-08dbc4bcacbd', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'535b17fc-6695-46c8-f6d5-08dbc4bcacb8')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6d34f9f8-95b7-4771-1a2d-08dbcf2fb92c', N'The Graduate', 1, N'85400afb-7a39-4ad0-054e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a67997e3-8466-4bc1-1a2e-08dbcf2fb92c', N'Mad Max', 0, N'85400afb-7a39-4ad0-054e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'248eb375-2811-4a60-1a2f-08dbcf2fb92c', N'One Flew Over the Cuckoo''s Nest', 0, N'85400afb-7a39-4ad0-054e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a89a7ed9-9053-4a00-1a30-08dbcf2fb92c', N'The Night of the Hunter', 0, N'85400afb-7a39-4ad0-054e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd1d25d33-a842-46ed-1a31-08dbcf2fb92c', N'Russell Crowe', 1, N'45d450f7-bb56-4884-054f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ab774295-dd06-4ca1-1a32-08dbcf2fb92c', N'Tom Hanks', 0, N'45d450f7-bb56-4884-054f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'53f9b83f-75b6-42d0-1a33-08dbcf2fb92c', N'Ed Harris', 0, N'45d450f7-bb56-4884-054f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'bf8fe41f-3ed0-4dcf-1a34-08dbcf2fb92c', N'Javier Bardem', 0, N'45d450f7-bb56-4884-054f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'3014d1da-c8ad-4c37-1a35-08dbcf2fb92c', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'e59bfea8-40ba-4009-0550-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'74d57592-0488-4174-1a36-08dbcf2fb92c', N'American Sniper', 0, N'e59bfea8-40ba-4009-0550-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'8280f6d1-6f57-430c-1a37-08dbcf2fb92c', N'Boyhood', 0, N'e59bfea8-40ba-4009-0550-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd78f4df7-0430-4590-1a38-08dbcf2fb92c', N'The Grand Budapest Hotel', 0, N'e59bfea8-40ba-4009-0550-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c12622d1-2ac7-40e4-1a39-08dbcf2fb92c', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'01bbcdf5-5c01-4d60-0551-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'24f161a4-41af-42d4-1a3a-08dbcf2fb92c', N'That is so fetch.', 0, N'01bbcdf5-5c01-4d60-0551-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'44e44293-2f7c-411f-1a3b-08dbcf2fb92c', N'I am big! It''s the pictures that got small.', 0, N'01bbcdf5-5c01-4d60-0551-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'bdb350c1-65f1-4482-1a3c-08dbcf2fb92c', N'Mother of mercy, is this the end of Rico?', 0, N'01bbcdf5-5c01-4d60-0551-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6cca3d21-a4b2-485f-1a3d-08dbcf2fb92c', N'The Two Towers', 1, N'42cf64bf-aed3-4dc6-0552-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a8739708-be8d-4abe-1a3e-08dbcf2fb92c', N'Life, the Universe and Everything', 0, N'42cf64bf-aed3-4dc6-0552-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'3d2cfb87-4d1f-451c-1a3f-08dbcf2fb92c', N'The Mysterious Island', 0, N'42cf64bf-aed3-4dc6-0552-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'76ae7caa-e2ae-46b7-1a40-08dbcf2fb92c', N'A Connecticut Yankee in King Arthur''s Court', 0, N'42cf64bf-aed3-4dc6-0552-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2747d2fd-dd90-4533-1a41-08dbcf2fb92c', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'1821ffd5-a9a7-4a2a-0553-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'41adc628-8b59-40fc-1a42-08dbcf2fb92c', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'1821ffd5-a9a7-4a2a-0553-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2f5618b7-e508-4a22-1a43-08dbcf2fb92c', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'1821ffd5-a9a7-4a2a-0553-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'3eebd783-46da-4ab4-1a44-08dbcf2fb92c', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'1821ffd5-a9a7-4a2a-0553-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'5afe3a9e-1582-4643-1a45-08dbcf2fb92c', N'The Graduate', 1, N'19e18fe3-42a7-432a-0554-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd4ca37c1-913d-4d2b-1a46-08dbcf2fb92c', N'Mad Max', 0, N'19e18fe3-42a7-432a-0554-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a4ef065f-ad08-4d3d-1a47-08dbcf2fb92c', N'One Flew Over the Cuckoo''s Nest', 0, N'19e18fe3-42a7-432a-0554-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'106bf95c-ed18-4e38-1a48-08dbcf2fb92c', N'The Night of the Hunter', 0, N'19e18fe3-42a7-432a-0554-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'97c02e22-eaa8-4af6-1a49-08dbcf2fb92c', N'Russell Crowe', 1, N'79778269-7e4c-48bf-0555-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'08fb86db-a038-4d34-1a4a-08dbcf2fb92c', N'Tom Hanks', 0, N'79778269-7e4c-48bf-0555-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd8a13a47-49db-49b5-1a4b-08dbcf2fb92c', N'Ed Harris', 0, N'79778269-7e4c-48bf-0555-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'267a9f8a-5930-4b6d-1a4c-08dbcf2fb92c', N'Javier Bardem', 0, N'79778269-7e4c-48bf-0555-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'cf43010f-79d2-48b1-1a4d-08dbcf2fb92c', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'698ef58a-cdb1-44d7-0556-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6ae7f39b-da22-4c74-1a4e-08dbcf2fb92c', N'American Sniper', 0, N'698ef58a-cdb1-44d7-0556-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'33a3d281-7362-48e3-1a4f-08dbcf2fb92c', N'Boyhood', 0, N'698ef58a-cdb1-44d7-0556-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2450c85e-c54c-48ae-1a50-08dbcf2fb92c', N'The Grand Budapest Hotel', 0, N'698ef58a-cdb1-44d7-0556-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'01fa6681-c469-4851-1a51-08dbcf2fb92c', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'107fc7d6-39c1-4530-0557-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'38c3ca36-c35e-431f-1a52-08dbcf2fb92c', N'That is so fetch.', 0, N'107fc7d6-39c1-4530-0557-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'31de5d97-5cb7-4557-1a53-08dbcf2fb92c', N'I am big! It''s the pictures that got small.', 0, N'107fc7d6-39c1-4530-0557-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'9db70362-26ea-4b1d-1a54-08dbcf2fb92c', N'Mother of mercy, is this the end of Rico?', 0, N'107fc7d6-39c1-4530-0557-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4f0955fe-b572-41b6-1a55-08dbcf2fb92c', N'The Two Towers', 1, N'3ed436ee-a2fc-4fcd-0558-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4f3bd4aa-b6b1-46f3-1a56-08dbcf2fb92c', N'Life, the Universe and Everything', 0, N'3ed436ee-a2fc-4fcd-0558-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ed231f9b-05b2-4487-1a57-08dbcf2fb92c', N'The Mysterious Island', 0, N'3ed436ee-a2fc-4fcd-0558-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'c4a183f4-2643-4a9c-1a58-08dbcf2fb92c', N'A Connecticut Yankee in King Arthur''s Court', 0, N'3ed436ee-a2fc-4fcd-0558-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'06c8f3fb-a1d2-41a0-1a59-08dbcf2fb92c', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'4c457ad4-2e14-4e3f-0559-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'e6fe76d7-5887-4045-1a5a-08dbcf2fb92c', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'4c457ad4-2e14-4e3f-0559-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'2c295815-15aa-405f-1a5b-08dbcf2fb92c', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'4c457ad4-2e14-4e3f-0559-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'239c67f0-3e0c-4012-1a5c-08dbcf2fb92c', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'4c457ad4-2e14-4e3f-0559-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'9be3a148-8d60-4831-1a5d-08dbcf2fb92c', N'The Graduate', 1, N'53fdfd5f-b2f3-44df-055a-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ff34423d-8fe7-40d3-1a5e-08dbcf2fb92c', N'Mad Max', 0, N'53fdfd5f-b2f3-44df-055a-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'52e7655a-2c5a-4ca2-1a5f-08dbcf2fb92c', N'One Flew Over the Cuckoo''s Nest', 0, N'53fdfd5f-b2f3-44df-055a-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'88989398-5ccd-4a56-1a60-08dbcf2fb92c', N'The Night of the Hunter', 0, N'53fdfd5f-b2f3-44df-055a-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'12b56f4e-92e4-4edc-1a61-08dbcf2fb92c', N'Russell Crowe', 1, N'f0eabd0f-2898-4846-055b-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'14d6329d-3dce-4c33-1a62-08dbcf2fb92c', N'Tom Hanks', 0, N'f0eabd0f-2898-4846-055b-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'06a608e0-98c0-46b6-1a63-08dbcf2fb92c', N'Ed Harris', 0, N'f0eabd0f-2898-4846-055b-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'36040b8e-23ce-44c1-1a64-08dbcf2fb92c', N'Javier Bardem', 0, N'f0eabd0f-2898-4846-055b-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a1a19fd8-e6f8-4589-1a65-08dbcf2fb92c', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'a01471ac-2935-4dad-055c-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'224f68be-ac48-46cd-1a66-08dbcf2fb92c', N'American Sniper', 0, N'a01471ac-2935-4dad-055c-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'11cce50f-2109-4de3-1a67-08dbcf2fb92c', N'Boyhood', 0, N'a01471ac-2935-4dad-055c-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4e4984e4-34a3-4c45-1a68-08dbcf2fb92c', N'The Grand Budapest Hotel', 0, N'a01471ac-2935-4dad-055c-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'825f7f4b-e313-4f1c-1a69-08dbcf2fb92c', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'49d244a3-6426-4ee6-055d-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'1f65ee63-389d-41d5-1a6a-08dbcf2fb92c', N'That is so fetch.', 0, N'49d244a3-6426-4ee6-055d-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'342eb30f-5f3c-484d-1a6b-08dbcf2fb92c', N'I am big! It''s the pictures that got small.', 0, N'49d244a3-6426-4ee6-055d-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f0d12de6-ed16-4801-1a6c-08dbcf2fb92c', N'Mother of mercy, is this the end of Rico?', 0, N'49d244a3-6426-4ee6-055d-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ebe8f838-ee74-4bc5-1a6d-08dbcf2fb92c', N'The Two Towers', 1, N'ed9199ec-dfb3-4004-055e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'140fb82e-b918-41a3-1a6e-08dbcf2fb92c', N'Life, the Universe and Everything', 0, N'ed9199ec-dfb3-4004-055e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b6ec210d-1c10-4f90-1a6f-08dbcf2fb92c', N'The Mysterious Island', 0, N'ed9199ec-dfb3-4004-055e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b1e79178-6a41-4e04-1a70-08dbcf2fb92c', N'A Connecticut Yankee in King Arthur''s Court', 0, N'ed9199ec-dfb3-4004-055e-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'1e4447b7-9216-40e9-1a71-08dbcf2fb92c', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'5066dd40-0329-490b-055f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'78c8f05a-5280-490d-1a72-08dbcf2fb92c', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'5066dd40-0329-490b-055f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'6a671cab-a84c-49fe-1a73-08dbcf2fb92c', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'5066dd40-0329-490b-055f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4fc99909-2106-469b-1a74-08dbcf2fb92c', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'5066dd40-0329-490b-055f-08dbcf2fb920')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'ec5d5310-5407-4327-7ca8-08dbd465216d', N'The Graduate', 1, N'5cb0456f-8e0d-4998-4e46-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'94338a99-523c-4568-7ca9-08dbd465216d', N'Mad Max', 0, N'5cb0456f-8e0d-4998-4e46-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'836273ac-0620-4ea2-7caa-08dbd465216d', N'One Flew Over the Cuckoo''s Nest', 0, N'5cb0456f-8e0d-4998-4e46-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'debff94f-0e47-4d66-7cab-08dbd465216d', N'The Night of the Hunter', 0, N'5cb0456f-8e0d-4998-4e46-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'0ccf6392-e31e-4c08-7cac-08dbd465216d', N'Russell Crowe', 1, N'7559de6d-2c2a-4273-4e47-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'1d34964f-4e5b-4a44-7cad-08dbd465216d', N'Tom Hanks', 0, N'7559de6d-2c2a-4273-4e47-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'56f101c6-c8df-4684-7cae-08dbd465216d', N'Ed Harris', 0, N'7559de6d-2c2a-4273-4e47-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'5c661bdc-9026-4d5c-7caf-08dbd465216d', N'Javier Bardem', 0, N'7559de6d-2c2a-4273-4e47-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'8c698ee3-84a0-450f-7cb0-08dbd465216d', N'Birdman or (The Unexpected Virtue of Ignorance)', 1, N'24b0f3ae-c1d5-4896-4e48-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'f17b5a5a-ebb0-4cca-7cb1-08dbd465216d', N'American Sniper', 0, N'24b0f3ae-c1d5-4896-4e48-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'eec355b6-356c-4935-7cb2-08dbd465216d', N'Boyhood', 0, N'24b0f3ae-c1d5-4896-4e48-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a84a62a2-f256-40f3-7cb3-08dbd465216d', N'The Grand Budapest Hotel', 0, N'24b0f3ae-c1d5-4896-4e48-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'7a55fe8f-a9fa-4d8d-7cb4-08dbd465216d', N'Life is a banquet, and most poor suckers are starving to death!', 1, N'e6b825d9-b8d1-436e-4e49-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b084cdec-0315-4408-7cb5-08dbd465216d', N'That is so fetch.', 0, N'e6b825d9-b8d1-436e-4e49-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a5accd31-f466-4c48-7cb6-08dbd465216d', N'I am big! It''s the pictures that got small.', 0, N'e6b825d9-b8d1-436e-4e49-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'89f28a35-6be8-425e-7cb7-08dbd465216d', N'Mother of mercy, is this the end of Rico?', 0, N'e6b825d9-b8d1-436e-4e49-08dbd4652168')
GO
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'8a9de9e3-a52a-4465-7cb8-08dbd465216d', N'The Two Towers', 1, N'54f73940-7def-4bdb-4e4a-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a57f7ee5-eaec-439a-7cb9-08dbd465216d', N'Life, the Universe and Everything', 0, N'54f73940-7def-4bdb-4e4a-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'4ac0a79d-f5f2-42a3-7cba-08dbd465216d', N'The Mysterious Island', 0, N'54f73940-7def-4bdb-4e4a-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'a5f131ed-0b75-4f99-7cbb-08dbd465216d', N'A Connecticut Yankee in King Arthur''s Court', 0, N'54f73940-7def-4bdb-4e4a-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'bdeddd29-5b09-4eb9-7cbc-08dbd465216d', N'A cyborg must protect a ten-year-old boy from a more powerful cyborg.', 1, N'a5d2b26f-e130-4a2b-4e4b-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'22203f5d-473c-4ab5-7cbd-08dbd465216d', N'A criminal pleads insanity and is admitted to a mental institution.', 0, N'a5d2b26f-e130-4a2b-4e4b-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'd1fc2f20-195e-4754-7cbe-08dbd465216d', N'An NYPD officer tries to save his wife taken hostage by terrorists during a Christmas party.', 0, N'a5d2b26f-e130-4a2b-4e4b-08dbd4652168')
INSERT [dbo].[McqChoices] ([Id], [Content], [IsCorrect], [McqQuestionId]) VALUES (N'b260f79e-3b11-4fe2-7cbf-08dbd465216d', N'A car salesman''s inept crime falls apart due to his and his henchmen''s bungling.', 0, N'a5d2b26f-e130-4a2b-4e4b-08dbd4652168')
GO
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'dea345a3-833b-4a89-f6ba-08dbc4bcacb8', N'Which film won the Academy Award for Best Picture in 2014?', N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'5a0c33c5-f7ac-49e3-f6bb-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'3d102481-515b-49a1-f6bc-08dbc4bcacb8', N'Which film won the Academy Award for Best Picture in 2014?', N'215adbdd-0b6d-40a5-95f1-effe85229b9e')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'8caa9bad-bbb6-454c-f6bd-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'215adbdd-0b6d-40a5-95f1-effe85229b9e')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'43f8f7e6-bb79-46cc-f6be-08dbc4bcacb8', N'What is the plot of the movie Terminator 2: Judgment Day?', N'215adbdd-0b6d-40a5-95f1-effe85229b9e')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'864762d3-fe68-4f20-f6bf-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'a1c19da3-4db4-4bf2-b2a5-a1d561b0b2ee')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'388f6369-163d-4d9a-f6c0-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'a1c19da3-4db4-4bf2-b2a5-a1d561b0b2ee')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'375c0a1c-649c-4401-f6c1-08dbc4bcacb8', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'4cbd9f9c-55df-4752-a190-1c9daad20869')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'9a93881f-8afe-41ad-f6c2-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'4cbd9f9c-55df-4752-a190-1c9daad20869')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'84a46d31-37ad-4dca-f6c3-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'4cbd9f9c-55df-4752-a190-1c9daad20869')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'2cc3988c-cbd9-41da-f6c4-08dbc4bcacb8', N'Which film contains the character ''Mrs. Robinson''?', N'72930d6e-30a8-48d8-b8d0-130cd4f61ea1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'091f0f04-a3e9-4976-f6c5-08dbc4bcacb8', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'72930d6e-30a8-48d8-b8d0-130cd4f61ea1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'd196edfb-5b24-4ef9-f6c6-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'72930d6e-30a8-48d8-b8d0-130cd4f61ea1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'008bbd19-c950-4b1b-f6c7-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'72930d6e-30a8-48d8-b8d0-130cd4f61ea1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'01286087-ffcf-4a90-f6c8-08dbc4bcacb8', N'Which film contains the character ''Mrs. Robinson''?', N'4b894308-1681-4d39-bc30-cb6571e79f85')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'efc656a5-5ba3-4863-f6c9-08dbc4bcacb8', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'4b894308-1681-4d39-bc30-cb6571e79f85')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'd2319f15-de1d-4b57-f6ca-08dbc4bcacb8', N'Which film contains the character ''Mrs. Robinson''?', N'1eec3ded-baa0-4a3b-9244-c8ccae3699c5')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'920841fe-97bf-4767-f6cb-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'1eec3ded-baa0-4a3b-9244-c8ccae3699c5')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'6c1c2532-5c18-4b81-f6cc-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'1eec3ded-baa0-4a3b-9244-c8ccae3699c5')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'9fce4151-9ae2-4f42-f6cd-08dbc4bcacb8', N'Which film won the Academy Award for Best Picture in 2014?', N'4910d433-628f-42ab-9ad5-d5e861f89f17')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'8deabef4-553a-4a36-f6ce-08dbc4bcacb8', N'What is the plot of the movie Terminator 2: Judgment Day?', N'4910d433-628f-42ab-9ad5-d5e861f89f17')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'ab878ae7-4144-48aa-f6cf-08dbc4bcacb8', N'Which film contains the character ''Mrs. Robinson''?', N'740433a6-9745-42ce-b1d3-7293764c5bc1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'b84665e4-d31b-442e-f6d0-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'740433a6-9745-42ce-b1d3-7293764c5bc1')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'0fcc5814-cc32-4f14-f6d1-08dbc4bcacb8', N'Which film contains the character ''Mrs. Robinson''?', N'19700903-8b4b-47b9-a873-e2a4f068c45a')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'dad1c6ef-8834-4913-f6d2-08dbc4bcacb8', N'Which film won the Academy Award for Best Picture in 2014?', N'19700903-8b4b-47b9-a873-e2a4f068c45a')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'edcf8d15-82c1-4e15-f6d3-08dbc4bcacb8', N'Which of these quotes is from the film ''Auntie Mame''?', N'19700903-8b4b-47b9-a873-e2a4f068c45a')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'16cafee7-cc0b-48c8-f6d4-08dbc4bcacb8', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'19700903-8b4b-47b9-a873-e2a4f068c45a')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'535b17fc-6695-46c8-f6d5-08dbc4bcacb8', N'What is the plot of the movie Terminator 2: Judgment Day?', N'19700903-8b4b-47b9-a873-e2a4f068c45a')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'85400afb-7a39-4ad0-054e-08dbcf2fb920', N'Which film contains the character ''Mrs. Robinson''?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'45d450f7-bb56-4884-054f-08dbcf2fb920', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'e59bfea8-40ba-4009-0550-08dbcf2fb920', N'Which film won the Academy Award for Best Picture in 2014?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'01bbcdf5-5c01-4d60-0551-08dbcf2fb920', N'Which of these quotes is from the film ''Auntie Mame''?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'42cf64bf-aed3-4dc6-0552-08dbcf2fb920', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'1821ffd5-a9a7-4a2a-0553-08dbcf2fb920', N'What is the plot of the movie Terminator 2: Judgment Day?', N'77d68364-fbd5-43dd-8720-926da682b0d7')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'19e18fe3-42a7-432a-0554-08dbcf2fb920', N'Which film contains the character ''Mrs. Robinson''?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'79778269-7e4c-48bf-0555-08dbcf2fb920', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'698ef58a-cdb1-44d7-0556-08dbcf2fb920', N'Which film won the Academy Award for Best Picture in 2014?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'107fc7d6-39c1-4530-0557-08dbcf2fb920', N'Which of these quotes is from the film ''Auntie Mame''?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'3ed436ee-a2fc-4fcd-0558-08dbcf2fb920', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'4c457ad4-2e14-4e3f-0559-08dbcf2fb920', N'What is the plot of the movie Terminator 2: Judgment Day?', N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'53fdfd5f-b2f3-44df-055a-08dbcf2fb920', N'Which film contains the character ''Mrs. Robinson''?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'f0eabd0f-2898-4846-055b-08dbcf2fb920', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'a01471ac-2935-4dad-055c-08dbcf2fb920', N'Which film won the Academy Award for Best Picture in 2014?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'49d244a3-6426-4ee6-055d-08dbcf2fb920', N'Which of these quotes is from the film ''Auntie Mame''?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'ed9199ec-dfb3-4004-055e-08dbcf2fb920', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'5066dd40-0329-490b-055f-08dbcf2fb920', N'What is the plot of the movie Terminator 2: Judgment Day?', N'7d55216c-dcd4-4013-8461-f1aac771417b')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'5cb0456f-8e0d-4998-4e46-08dbd4652168', N'Which film contains the character ''Mrs. Robinson''?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'7559de6d-2c2a-4273-4e47-08dbd4652168', N'Who won the 2000 Academy Award for Best Leading Actor for playing the role of Maximus Decimus Meridius in Gladiator?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'24b0f3ae-c1d5-4896-4e48-08dbd4652168', N'Which film won the Academy Award for Best Picture in 2014?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'e6b825d9-b8d1-436e-4e49-08dbd4652168', N'Which of these quotes is from the film ''Auntie Mame''?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'54f73940-7def-4bdb-4e4a-08dbd4652168', N'Which piece of written work starts with the line ''Aragorn sped on up the hill.''?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
INSERT [dbo].[McqQuestions] ([Id], [Content], [AssignmentId]) VALUES (N'a5d2b26f-e130-4a2b-4e4b-08dbd4652168', N'What is the plot of the movie Terminator 2: Judgment Day?', N'6965b04a-e57a-4cc0-ac98-c19c61eaa497')
GO
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'b7563fa0-addb-4873-9f8e-5547ce12b07f', N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'7ccc2cf5-d906-4e66-b58f-92edd12b3556', N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'8793defb-16fc-4c93-8d08-9d31c40ceeb2', N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'8613f928-694e-4a8e-8b3c-bd51936609ab', N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'a75133ae-48ec-4448-96d4-d1d76f6c0087', N'edb5ccb1-da56-47bb-70ef-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'df009258-f09e-4925-8ab4-b0220bbb3c6d', N'2a4b93d6-eb07-4e77-70f0-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'b7563fa0-addb-4873-9f8e-5547ce12b07f', N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'7ccc2cf5-d906-4e66-b58f-92edd12b3556', N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'8793defb-16fc-4c93-8d08-9d31c40ceeb2', N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'df009258-f09e-4925-8ab4-b0220bbb3c6d', N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'8613f928-694e-4a8e-8b3c-bd51936609ab', N'cdc16e9d-908b-4c3c-70f3-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'51440a98-fd4d-477b-b9dd-a3639376ba73', N'30ac48ad-3441-4825-70f7-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'e4ea37aa-95a4-4391-9eb0-ee28fbfc8fd7', N'30ac48ad-3441-4825-70f7-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'51440a98-fd4d-477b-b9dd-a3639376ba73', N'25f94752-856c-4477-70fb-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'e4ea37aa-95a4-4391-9eb0-ee28fbfc8fd7', N'25f94752-856c-4477-70fb-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'e4ea37aa-95a4-4391-9eb0-ee28fbfc8fd7', N'28d63dfa-4dae-4a0a-70ff-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'51440a98-fd4d-477b-b9dd-a3639376ba73', N'a71a2527-6721-4c23-7100-08dbc4bcacbd')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'6d34f9f8-95b7-4771-1a2d-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'd1d25d33-a842-46ed-1a31-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'3014d1da-c8ad-4c37-1a35-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'c12622d1-2ac7-40e4-1a39-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'6cca3d21-a4b2-485f-1a3d-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', N'2747d2fd-dd90-4533-1a41-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'5afe3a9e-1582-4643-1a45-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'97c02e22-eaa8-4af6-1a49-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'cf43010f-79d2-48b1-1a4d-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'01fa6681-c469-4851-1a51-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'4f0955fe-b572-41b6-1a55-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', N'06c8f3fb-a1d2-41a0-1a59-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'9be3a148-8d60-4831-1a5d-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'12b56f4e-92e4-4edc-1a61-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'a1a19fd8-e6f8-4589-1a65-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'825f7f4b-e313-4f1c-1a69-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'ebe8f838-ee74-4bc5-1a6d-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', N'1e4447b7-9216-40e9-1a71-08dbcf2fb92c')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'39f7f7d5-3491-4a91-bc7a-1dc3e520f834', N'0ccf6392-e31e-4c08-7cac-08dbd465216d')
INSERT [dbo].[McqUserAnswer] ([SubmissionId], [MCQChoiceId]) VALUES (N'39f7f7d5-3491-4a91-bc7a-1dc3e520f834', N'a84a62a2-f256-40f3-7cb3-08dbd465216d')
GO
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'66f890fd-b661-4590-fca6-08dbbf209d15', N'{"Intro":"I am HuynhGiang59","Experience":"I am HuynhGiang59"}', N'RequestToBecomeInstructor', N'Dismissed', NULL, CAST(N'2023-09-27T13:11:40.3433333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'37761db6-7f04-407c-fca7-08dbbf209d15', N'{"Intro":"I am HuynhGiang59 # 2","Experience":"I am HuynhGiang59 #2"}', N'RequestToBecomeInstructor', N'Approved', NULL, CAST(N'2023-09-27T13:12:04.6000000' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'b9ec39e8-1f58-41cb-0f61-08dbcb848a40', N'{"Message":"Reporting unauthorized sales","Conversation":"75d60c97-b560-4779-9a31-c5855c24def1"}', N'ReportGroup', N'None', NULL, CAST(N'2023-10-13T07:37:12.1133333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'2c9b74e3-0b2b-4f0c-0f62-08dbcb848a40', N'{"Message":"Reporting unauthorized sales","Conversation":"d683c0d3-ffd6-430b-acf3-c13581a80c93"}', N'ReportGroup', N'None', NULL, CAST(N'2023-10-13T08:03:04.8933333' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'71af97a5-7833-45f0-33c4-08dbcc04cf65', N'{"Conversation":"75d60c97-b560-4779-9a31-c5855c24def1"}', N'InviteMember', N'Approved', N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', CAST(N'2023-10-13T22:55:24.4733333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'32030960-325b-404d-33c5-08dbcc04cf65', N'{"Conversation":"75d60c97-b560-4779-9a31-c5855c24def1"}', N'InviteMember', N'None', N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', CAST(N'2023-10-13T22:55:24.4733333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'21605209-b68f-4761-abef-08dbcd82b725', N'{"Gateway":"TechComBank","AccountNumber":"123456123456","AccountHolderName":"Ho Hoang Loc","Amount":100000}', N'RequestWithdrawal', N'None', NULL, CAST(N'2023-10-15T20:29:10.7233333' AS DateTime2), N'39dcb58a-5a86-4220-8366-518be3efe406')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'87e442fe-71e8-4251-0ed1-08dbcdecb348', N'{"Message":"Unreliable content","Course":"090413cd-dcb2-49e9-b0bb-79933ff1cb3a"}', N'ReportCourse', N'None', NULL, CAST(N'2023-10-16T09:07:50.9533333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'9778c319-dd8d-4263-f062-08dbd0b3e2de', N'{"Intro":"Watashi wa DangHang","Experience":"Watashi wa DangHang 123456"}', N'RequestToBecomeInstructor', N'Approved', NULL, CAST(N'2023-10-19T21:58:42.7766667' AS DateTime2), N'603d925c-147c-4d22-82cf-23633d1c4a80')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'8aaf0a8f-d020-4b06-f063-08dbd0b3e2de', N'{"Conversation":"22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7"}', N'InviteMember', N'Approved', N'820ef64f-8e25-4486-86e5-027d4fddb31d', CAST(N'2023-10-19T22:14:49.0366667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'd9885cf4-b71a-4e67-f064-08dbd0b3e2de', N'{"Conversation":"22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7"}', N'InviteMember', N'Dismissed', N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', CAST(N'2023-10-19T22:14:49.0366667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'ae1e12c6-656e-4e55-08a1-08dbd0c0695a', N'{"Gateway":"VNPay","AccountNumber":"1234566541234532","AccountHolderName":"Card holder Card holder","Amount":600000}', N'RequestWithdrawal', N'Approved', NULL, CAST(N'2023-10-19T23:28:22.6000000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'753f55ee-28ea-4a19-d007-08dbd4628621', N'{"Conversation":"22eb6b1d-3ea1-4c21-baeb-ede77c52b4e7"}', N'InviteMember', N'Approved', N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', CAST(N'2023-10-24T14:26:22.8133333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'4171d068-6b87-44c5-d008-08dbd4628621', N'{"Message":"Outdated content","Course":"00ef965c-d74e-487b-ab36-55619d89ef37"}', N'ReportCourse', N'None', NULL, CAST(N'2023-10-24T15:01:49.3633333' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
INSERT [dbo].[Notifications] ([Id], [Message], [Type], [Status], [ReceiverId], [CreationTime], [CreatorId]) VALUES (N'45f7e012-888c-46f5-df76-08dbd6c6dcf3', N'{"Gateway":"VNPay","AccountNumber":"123456789987654321","AccountHolderName":"Nguyen Van A","Amount":400000}', N'RequestWithdrawal', N'Approved', NULL, CAST(N'2023-10-27T15:29:40.2500000' AS DateTime2), N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0')
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'484275b5-e6f3-4ccc-6089-08dbbbd82e06', 0, N'Front-End Web Development', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e11735d1-4e40-421b-608a-08dbbbd82e06', 1, N'Introduction to HTML', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a2f13f55-75c5-4d84-608b-08dbbbd82e06', 2, N'Intermediate HTML', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd320bfdc-b16f-447b-608c-08dbbbd82e06', 3, N'Multi-Page Websites', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6f1871cf-8000-444b-608d-08dbbbd82e06', 4, N'Introduction to CSS', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f945df2b-2233-4b78-608e-08dbbbd82e06', 5, N'CSS Properties', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'417bde37-4082-42fe-608f-08dbbbd82e06', 6, N'Intermediate CSS', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'da9f330c-7616-4831-6090-08dbbbd82e06', 7, N'Advanced CSS', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dd92e208-b4e2-4e00-6091-08dbbbd82e06', 8, N'Flexbox', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6e6c6c66-d826-4bfc-6092-08dbbbd82e06', 9, N'Grid', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e4a172d5-7ba2-4abd-6093-08dbbbd82e06', 10, N'Bootstrap', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fc495ebf-d6a8-4831-6094-08dbbbd82e06', 11, N'Web Design School - Create a Website that People Love', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e8503454-97e8-45f1-6095-08dbbbd82e06', 12, N'Capstone Project 2 - Personal Site', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fa2a1baa-32f6-4fe8-6096-08dbbbd82e06', 13, N'Introduction to Javascript ES6', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1c039d3e-acae-4445-6097-08dbbbd82e06', 14, N'Intermediate Javascript', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'98ec0a64-4a92-4aab-6098-08dbbbd82e06', 15, N'The Document Object Model (DOM)', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'da390ab2-756e-4ae1-6099-08dbbbd82e06', 16, N'Boss Level Challenge 1 - The Dicee Game', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e8f54699-f305-4d97-609a-08dbbbd82e06', 17, N'Advanced Javascript and DOM Manipulation', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e3e2f12e-d634-42a1-609b-08dbbbd82e06', 18, N'jQuery', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'eef5048b-bf1c-4e96-609c-08dbbbd82e06', 19, N'Boss Level Challenge 2 - The Simon Game', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'97596391-dc09-4bc5-609d-08dbbbd82e06', 20, N'The Unix Command Line', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'de38e571-9527-47fe-609e-08dbbbd82e06', 21, N'Backend Web Development', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'098775e2-9545-4bfb-609f-08dbbbd82e06', 22, N'Node.js', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'43081548-a9b2-48a3-60a0-08dbbbd82e06', 23, N'Express.js with Node.js', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6b78689e-328e-4265-60a1-08dbbbd82e06', 24, N'EJS', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1dc3ed1c-2056-407a-60a2-08dbbbd82e06', 25, N'Capstone Project - Todolist Application', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f6913d0c-3337-402c-60a3-08dbbbd82e06', 26, N'Git, Github and Version Control', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'42cd112b-bd2a-4bf1-60a4-08dbbbd82e06', 27, N'Application Programming Interfaces (APIs)', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1eb0a421-3a3a-4e7c-60a5-08dbbbd82e06', 28, N'Capstone Project - Use a Public API', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a77a70aa-1a01-4bec-60a6-08dbbbd82e06', 29, N'Build Your Own API', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1f7d0a9c-4342-4b21-60a7-08dbbbd82e06', 30, N'Databases', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0d422e1b-6505-4c80-60a8-08dbbbd82e06', 31, N'SQL', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a17c1ce8-180a-4e27-60a9-08dbbbd82e06', 32, N'MongoDB', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'582345d4-fc88-4147-60aa-08dbbbd82e06', 33, N'Mongoose', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a1fcdc04-834c-4b5a-60ab-08dbbbd82e06', 34, N'Putting Everything Together', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'07023c77-cd77-40fb-60ac-08dbbbd82e06', 35, N'Deploying Your Web Application', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6c41c0d6-d63c-49a0-60ad-08dbbbd82e06', 36, N'Boss Level Challenge 4 - Blog Website Upgrade', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'571a317f-b77a-4e4f-60ae-08dbbbd82e06', 37, N'Authentication & Security', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'798de95d-c6a9-40ef-60af-08dbbbd82e06', 38, N'React.js', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7c78c129-db48-419d-60b0-08dbbbd82e06', 39, N'Web3 Decentralised App (DApp) Development with the Internet Computer', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0b8a31da-e3e4-44e4-60b1-08dbbbd82e06', 40, N'Build Your First Defi (Decentralised Finance) DApp - DBANK', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1f4a28f9-7c50-4462-60b2-08dbbbd82e06', 41, N'Deploying to the ICP Live Blockchain', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2c583e09-e481-4f5d-60b3-08dbbbd82e06', 42, N'Building DApps on ICP with a React Frontend', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f6600598-4df3-43b1-60b4-08dbbbd82e06', 43, N'Create Your Own Crypto Token', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.5400000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4dd579fa-c80d-44b4-60b5-08dbbbd82e06', 44, N'Minting NFTs and Building an NFT Marketplace like OpenSea', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'35615327-7534-4156-60b6-08dbbbd82e06', 45, N'Optional Module: Ask Angela Anything', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'37cd533a-ff93-41ef-60b7-08dbbbd82e06', 46, N'Next Steps', 0, N'69746c85-6109-4370-9334-1490cd2334b0', CAST(N'2023-09-23T08:55:36.4566667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'406c89ec-8b5a-446e-60b8-08dbbbd82e06', 0, N'Course Orientation', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'612ff6be-cdd4-421a-60b9-08dbbbd82e06', 1, N'An Introduction to Web Development', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cdf16ceb-0511-4e97-60ba-08dbbbd82e06', 2, N'HTML: The Essentials', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bc5b217f-f26d-4d91-60bb-08dbbbd82e06', 3, N'HTML: Next Steps & Semantics', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'52c8bd02-4be1-429e-60bc-08dbbbd82e06', 4, N'HTML: Forms & Tables', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'90418589-326b-4748-60bd-08dbbbd82e06', 5, N'CSS: The Very Basics', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6224c601-0c37-4fe2-60be-08dbbbd82e06', 6, N'The World of CSS Selectors', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'20393db8-67c1-4716-60bf-08dbbbd82e06', 7, N'The CSS Box Model', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2355cc69-c37f-4c8f-60c0-08dbbbd82e06', 8, N'Other Assorted Useful CSS Properties', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'346bae47-cc96-41e2-60c1-08dbbbd82e06', 9, N'Responsive CSS & Flexbox', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1d56abdf-01c7-4a3e-60c2-08dbbbd82e06', 10, N'Pricing Panel Project', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b63b587f-a696-4cbe-60c3-08dbbbd82e06', 11, N'CSS Frameworks: Bootstrap', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e928f782-9812-48af-60c4-08dbbbd82e06', 12, N'OPTIONAL Museum Of Candy Project', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3e42865f-4bc9-47e2-60c5-08dbbbd82e06', 13, N'JavaScript Basics!', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c8e0ea15-0c7f-4158-60c6-08dbbbd82e06', 14, N'JavaScript Strings and More', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'330d408b-4b91-48d1-60c7-08dbbbd82e06', 15, N'JavaScript Decision Making', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4350a9d1-defd-430f-60c8-08dbbbd82e06', 16, N'JavaScript Arrays', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'68f094a2-5346-40c6-60c9-08dbbbd82e06', 17, N'JavaScript Object Literals', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'66755533-67c7-4675-60ca-08dbbbd82e06', 18, N'Repeating Stuff With Loops', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b56081a0-4364-4aa1-60cb-08dbbbd82e06', 19, N'NEW: Introducing Functions', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b94472bf-4088-49e8-60cc-08dbbbd82e06', 20, N'Leveling Up Our Functions', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6601ce8d-3a48-487b-60cd-08dbbbd82e06', 21, N'Callbacks & Array Methods', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bd70be48-8f0c-4cff-60ce-08dbbbd82e06', 22, N'Newer JavaScript Features', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5fd7258b-6544-4992-60cf-08dbbbd82e06', 23, N'Introducing The World Of The DOM', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9d1bca6d-14cf-4bc6-60d0-08dbbbd82e06', 24, N'The Missing Piece: DOM Events', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'59cf8403-bfa7-4b20-60d1-08dbbbd82e06', 25, N'Score Keeper CodeAlong', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b45728a8-967c-42b8-60d2-08dbbbd82e06', 26, N'Async JavaScript: Oh Boy!', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b8e8eb6d-f7d9-4603-60d3-08dbbbd82e06', 27, N'AJAX and API''s', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8dfaafab-29d4-44c9-60d4-08dbbbd82e06', 28, N'Prototypes, Classes, & OOP', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'15b2a427-d51a-4132-60d5-08dbbbd82e06', 29, N'Mastering The Terminal', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c41ba948-a999-4ae0-60d6-08dbbbd82e06', 30, N'Our First Brush With Node', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd06e7e7f-3b62-4813-60d7-08dbbbd82e06', 31, N'Exploring Modules & The NPM Universe', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dab0e23c-19f3-4c56-60d8-08dbbbd82e06', 32, N'Creating Servers With Express', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2cea6d13-fce0-4ed1-60d9-08dbbbd82e06', 33, N'Creating Dynamic HTML With Templating', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6b6a5312-1ec1-480a-60da-08dbbbd82e06', 34, N'Defining RESTful Routes', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1f40dfd2-3a39-41e2-60db-08dbbbd82e06', 35, N'Our First Database: MongoDB', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0a0f9574-dbfe-4bb7-60dc-08dbbbd82e06', 36, N'Connecting To Mongo With Mongoose', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8ed0922f-e2d7-40d8-60dd-08dbbbd82e06', 37, N'Putting It All Together: Mongoose With Express', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7de02229-1594-4c6d-60de-08dbbbd82e06', 38, N'YelpCamp: Campgrounds CRUD', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'af9394a9-4c12-461b-60df-08dbbbd82e06', 39, N'Middleware: The Key To Express', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd5687e0f-207f-4686-60e0-08dbbbd82e06', 40, N'YelpCamp: Adding Basic Styles', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4a32afc4-d14e-42f7-60e1-08dbbbd82e06', 41, N'Handling Errors In Express Apps', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9ea030a8-87bf-459d-60e2-08dbbbd82e06', 42, N'YelpCamp: Errors & Validating Data', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5a6c7a37-dc54-4187-60e3-08dbbbd82e06', 43, N'Data Relationships With Mongo', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fd9387ea-8e15-4945-60e4-08dbbbd82e06', 44, N'Mongo Relationships With Express', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1259e8f0-a494-45c0-60e5-08dbbbd82e06', 45, N'YelpCamp: Adding The Reviews Model', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd34c75a0-7750-44cc-60e6-08dbbbd82e06', 46, N'Express Router & Cookies', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9ea272a6-19a9-4672-60e7-08dbbbd82e06', 47, N'Express Session & Flash', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'adc59c9e-63b6-4112-60e8-08dbbbd82e06', 48, N'YelpCamp: Restructuring & Flash', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b624297b-00ca-4e5e-60e9-08dbbbd82e06', 49, N'Authentication From "Scratch"', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cd23a934-8e1c-4d25-60ea-08dbbbd82e06', 50, N'YelpCamp: Adding In Authentication', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1c0dacc0-09d2-4d5b-60eb-08dbbbd82e06', 51, N'YelpCamp: Basic Authorization', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2f4e6b42-6806-4aef-60ec-08dbbbd82e06', 52, N'YelpCamp: Controllers & Star Ratings', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'55106f66-cd67-4676-60ed-08dbbbd82e06', 53, N'YelpCamp: Image Upload', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd079f2b1-6310-4e55-60ee-08dbbbd82e06', 54, N'YelpCamp: Adding Maps', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c088c732-a110-4952-60ef-08dbbbd82e06', 55, N'YelpCamp: Fancy Cluster Map', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5c85e07f-f790-497c-60f0-08dbbbd82e06', 56, N'YelpCamp: Styles Clean Up', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8e55fe5a-28de-47fb-60f1-08dbbbd82e06', 57, N'YelpCamp: Common Security Issues', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e9d094a5-7c0f-4a45-60f2-08dbbbd82e06', 58, N'YelpCamp: Deploying', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0f5880a2-1583-435e-60f3-08dbbbd82e06', 59, N'Introducing React', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ffa685f5-1911-47b9-60f4-08dbbbd82e06', 60, N'JSX In Detail', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ab0cfacb-dd20-4c47-60f5-08dbbbd82e06', 61, N'Local React Apps With Vite', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2d0f99c4-dab4-47cb-60f6-08dbbbd82e06', 62, N'Working With Props', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'92dea416-c11c-494c-60f7-08dbbbd82e06', 63, N'Shopping List Demo: keys, prop types, and more!', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a0ed1623-3072-4919-60f8-08dbbbd82e06', 64, N'React Events', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2d757374-b5ab-4215-60f9-08dbbbd82e06', 65, N'The Basics of React State', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'197bc599-26a1-4115-60fa-08dbbbd82e06', 66, N'Intermediate State Concepts', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd5a042f0-d5e5-4184-60fb-08dbbbd82e06', 67, N'Component Design', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ce9dcb7b-8748-437e-60fc-08dbbbd82e06', 68, N'React Forms', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7065db78-05cd-4b09-60fd-08dbbbd82e06', 69, N'Effects', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0d26a3ca-233b-40a4-60fe-08dbbbd82e06', 70, N'Material UI', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1c6f7007-120a-440e-60ff-08dbbbd82e06', 71, N'Building a Todo List With Material UI & Local Storage', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5614f33e-2627-49d0-6100-08dbbbd82e06', 72, N'BONUS: Fancy, More Advanced Todolist', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'382ac574-8a68-4957-6101-08dbbbd82e06', 73, N'The End :(', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6033333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ce5dcfab-603a-44bd-6102-08dbbbd82e06', 74, N'LEGACY CONTENT (The Old Version Of This Course)', 0, N'ba0bd425-5914-4ae5-97e0-c779c15f2b2a', CAST(N'2023-09-23T08:55:36.6366667' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'445e706e-652d-4062-6103-08dbbbd82e06', 0, N'Getting Started', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3c491475-959a-47d4-6104-08dbbbd82e06', 1, N'The Basics', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f074da5e-0b35-4808-6105-08dbbbd82e06', 2, N'Course Project - The Basics', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3ff2440b-0298-4255-6106-08dbbbd82e06', 3, N'Debugging', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a85acad7-7c4e-4354-6107-08dbbbd82e06', 4, N'Components & Databinding Deep Dive', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3eb3f79d-5aae-46d2-6108-08dbbbd82e06', 5, N'Course Project - Components & Databinding', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'99423e3f-5e46-419a-6109-08dbbbd82e06', 6, N'Directives Deep Dive', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2e121bd6-e740-4e1f-610a-08dbbbd82e06', 7, N'Course Project - Directives', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'93dc3dfb-72bb-4f7a-610b-08dbbbd82e06', 8, N'Using Services & Dependency Injection', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'facdb601-53cc-4cde-610c-08dbbbd82e06', 9, N'Course Project - Services & Dependency Injection', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'85dc7477-5170-4542-610d-08dbbbd82e06', 10, N'Changing Pages with Routing', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5c42c812-867c-4c0b-610e-08dbbbd82e06', 11, N'Course Project - Routing', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cd30a7fe-d2cd-43a6-610f-08dbbbd82e06', 12, N'Understanding Observables', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2192e7fe-c783-4588-6110-08dbbbd82e06', 13, N'Course Project - Observables', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2648f928-e208-4f9e-6111-08dbbbd82e06', 14, N'Handling Forms in Angular Apps', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'69c62411-f87c-4a4a-6112-08dbbbd82e06', 15, N'Course Project - Forms', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a0000775-9e1f-470e-6113-08dbbbd82e06', 16, N'Using Pipes to Transform Output', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd999faa4-d4f3-4cf1-6114-08dbbbd82e06', 17, N'Making Http Requests', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5bade9da-15cb-4f23-6115-08dbbbd82e06', 18, N'Course Project - Http', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f7384a05-d5ce-41ff-6116-08dbbbd82e06', 19, N'Authentication & Route Protection in Angular', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b31387a1-34f5-4db9-6117-08dbbbd82e06', 20, N'Dynamic Components', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7758b11f-8bb4-4404-6118-08dbbbd82e06', 21, N'Angular Modules & Optimizing Angular Apps', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'18decde0-acd0-490d-6119-08dbbbd82e06', 22, N'Deploying an Angular App', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e8e95a71-3d68-4e5f-611a-08dbbbd82e06', 23, N'Standalone Components', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9fe6123a-ea94-419a-611b-08dbbbd82e06', 24, N'Angular Signals', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6604d4b9-d7de-4078-611c-08dbbbd82e06', 25, N'Bonus: Using NgRx For State Management', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ce987db5-7055-4937-611d-08dbbbd82e06', 26, N'Bonus: Angular Universal', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'66f28046-f615-42d9-611e-08dbbbd82e06', 27, N'Angular Animations', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'518bdefa-caa9-429c-611f-08dbbbd82e06', 28, N'Adding Offline Capabilities with Service Workers', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dbd2a41b-769c-4bf6-6120-08dbbbd82e06', 29, N'A Basic Introduction to Unit Testing in Angular Apps', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7297141d-c5e4-4e11-6121-08dbbbd82e06', 30, N'Angular as a Platform & Closer Look at the CLI', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'38b8516c-0c6b-40cd-6122-08dbbbd82e06', 31, N'Angular Changes & New Features', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0d98f66d-2c07-4017-6123-08dbbbd82e06', 32, N'Course Roundup', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'667df223-2657-49e9-6124-08dbbbd82e06', 33, N'Bonus: TypeScript Introduction (for Angular 2 Usage)', 0, N'9b774995-5f60-4317-80ac-ad4e0730a2ed', CAST(N'2023-09-23T08:55:36.6833333' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'08e9a16f-f99a-45e8-6125-08dbbbd82e06', 0, N'Welcome and First Steps', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'367c5277-3147-4c69-6126-08dbbbd82e06', 1, N'HTML Fundamentals', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'249aacb6-006d-4ffd-6127-08dbbbd82e06', 2, N'CSS Fundamentals', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f8fcad0e-5e02-436c-6128-08dbbbd82e06', 3, N'Layouts: Floats, Flexbox, and CSS Grid Fundamentals', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd561f2d8-95be-4bcd-6129-08dbbbd82e06', 4, N'Web Design Rules and Framework', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2427cc5c-dea4-42da-612a-08dbbbd82e06', 5, N'Components and Layout Patterns', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a6f67988-0102-4ecc-612b-08dbbbd82e06', 6, N'Omnifood Project – Setup and Desktop Version', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'77eb4881-505a-44f9-612c-08dbbbd82e06', 7, N'Omnifood Project – Responsive Web Design', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'425fae09-166a-4491-612d-08dbbbd82e06', 8, N'Omnifood Project – Effects, Optimizations and Deployment', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'91cb91e8-4e2f-4b0b-612e-08dbbbd82e06', 9, N'The End!', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'52b5cd46-d2a7-4a11-612f-08dbbbd82e06', 10, N'[LEGACY] Old Course Version 1', 0, N'090413cd-dcb2-49e9-b0bb-79933ff1cb3a', CAST(N'2023-09-23T08:55:36.7700000' AS DateTime2), CAST(N'0001-01-01T00:00:00.0000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c1705eea-97ca-4305-7fc5-08dbc09c45f6', 0, N'Welcome', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd01c5472-611c-4489-7fc6-08dbc09c45f6', 1, N'What is Sales?', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b611b1e3-dd53-49b7-7fc7-08dbc09c45f6', 2, N'Part 1 - Building a Sales Relationship', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4332f718-4c86-4809-7fc8-08dbc09c45f6', 3, N'Part 2 - Diagnosing the Sale', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'23a50ac6-828f-4e2b-7fc9-08dbc09c45f6', 4, N'Part 3 - Prescribing a Solution', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c6721a2c-dfb1-4b27-7fca-08dbc09c45f6', 5, N'Part 4 - Objection Handling', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'86ec6263-4b48-436e-7fcb-08dbc09c45f6', 6, N'Part 5 - Closing Sales', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'117668fe-fc93-4253-7fcc-08dbc09c45f6', 7, N'Efficiency & Measurement in Sales', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f593a5ed-81b9-4a9f-7fcd-08dbc09c45f6', 8, N'Bonus', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7f8e3a15-0814-4654-7fce-08dbc09c45f6', 9, N'Bonus: Latest Content Updates', 0, N'b14177f1-c33a-46e4-b772-f65fada8a6b1', CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2), CAST(N'2023-09-29T10:29:22.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a1ac2dd1-3e03-4809-7fcf-08dbc09c45f6', 0, N'Introduction', 0, N'af36ec51-e721-4945-a73b-ab1e8765c619', CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2), CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b37f12a1-45c8-4a87-7fd0-08dbc09c45f6', 1, N'What is Customer Service', 0, N'af36ec51-e721-4945-a73b-ab1e8765c619', CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2), CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7635b499-dfc7-478a-7fd1-08dbc09c45f6', 2, N'Ways to Generate Ideas', 0, N'af36ec51-e721-4945-a73b-ab1e8765c619', CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2), CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'03d2e6ae-b158-4170-7fd2-08dbc09c45f6', 3, N'Wrap Up', 0, N'af36ec51-e721-4945-a73b-ab1e8765c619', CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2), CAST(N'2023-09-29T10:29:23.3400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1aa4f122-6155-4bec-7fd3-08dbc09c45f6', 0, N'Introduction & Setting Yourself Up for Success', 0, N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2), CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7c19ed4b-15cd-46f4-7fd4-08dbc09c45f6', 1, N'Business Development & Sales Strategy and Setting Your Goals', 0, N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2), CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fbbc48a0-a11d-499e-7fd5-08dbc09c45f6', 2, N'Outbound Lead Generation with Cold Emails', 0, N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2), CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e14b633b-f314-4b20-7fd6-08dbc09c45f6', 3, N'Sales Skills: From Your First Meeting to Closing the Deal', 0, N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2), CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6ca60a27-2bee-4c0c-7fd7-08dbc09c45f6', 4, N'Remote Sales Training', 0, N'f62cb645-5d02-43d4-ac53-9cabb114b9ca', CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2), CAST(N'2023-09-29T10:29:23.5700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'71c63277-6c11-4a09-7fd8-08dbc09c45f6', 0, N'Welcome to LinkedIn Machine', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b5ff2831-7883-4d27-7fd9-08dbc09c45f6', 1, N'LinkedIn Lead Generation Machine Foundations', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0d20e442-3cd6-475c-7fda-08dbc09c45f6', 2, N'LinkedIn Outbound Lead Generation', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'81ea7abb-18ed-453a-7fdb-08dbc09c45f6', 3, N'LinkedIn Social Selling & Content Marketing', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'662ac517-fd98-47af-7fdc-08dbc09c45f6', 4, N'How To Create High Quality LinkedIn Content', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c5e37904-f011-4601-7fdd-08dbc09c45f6', 5, N'LinkedIn General Marketing', 0, N'76bf19f6-1221-4242-97bb-0355035a3389', CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2), CAST(N'2023-09-29T10:29:23.7600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'15594a79-0e73-4754-7fde-08dbc09c45f6', 0, N'Introduction to the Customer Success Manager Course', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f933a1ac-a564-4c2a-7fdf-08dbc09c45f6', 1, N'The Basics of Customer Success Or Customer Success 101', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'314c36ca-06ff-465e-7fe0-08dbc09c45f6', 2, N'Customer Success Manager', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'16767479-fe1a-49aa-7fe1-08dbc09c45f6', 3, N'The Keys to be a Successful CSM and creating a world known CS brand', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c4051eeb-e44f-46a9-7fe2-08dbc09c45f6', 4, N'2 Basic Principles for Customer Success Process', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a21e4ae9-79f8-4f10-7fe3-08dbc09c45f6', 5, N'Where to find Customer Success Manager jobs', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ca82131c-a439-4117-7fe4-08dbc09c45f6', 6, N'The Plan, Lessons Learned and FAQs', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1c2e0b95-c1c7-4c9e-7fe5-08dbc09c45f6', 7, N'Review', 0, N'a2d066b4-0935-4b5a-b651-4ea97ea41f69', CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2), CAST(N'2023-09-29T10:29:24.0066667' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'44bc81f6-d8a6-4690-7fe6-08dbc09c45f6', 0, N'Selling, A Way of Life', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f03ea377-2844-4742-7fe7-08dbc09c45f6', 1, N'Professional or Amateur?', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bb084e96-60b7-44c8-7fe8-08dbc09c45f6', 2, N'The Most Important Sale', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'27b336c1-cc30-418f-7fe9-08dbc09c45f6', 3, N'The Price Myth', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7704ea29-4a79-4c2d-7fea-08dbc09c45f6', 4, N'Your Buyer''s Money', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'44383bc7-1f3a-4229-7feb-08dbc09c45f6', 5, N'The Magic of Agreement', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f8e15830-2c74-431a-7fec-08dbc09c45f6', 6, N'Give, Give, Give', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5559148a-8c97-44d6-7fed-08dbc09c45f6', 7, N'Massive Action', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a017e72f-bc43-4781-7fee-08dbc09c45f6', 8, N'Time', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a4dcc1e2-fad3-4840-7fef-08dbc09c45f6', 9, N'Attitude', 0, N'79e5e5be-2dc2-405a-8a54-0e3124d33249', CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2), CAST(N'2023-09-29T10:29:24.2533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'de63cabe-3090-4cff-2320-08dbca099599', 1, N'Section 1', 0, N'c538b99b-f724-4788-879f-adfe3b1a90ea', CAST(N'2023-10-11T10:24:32.3133333' AS DateTime2), CAST(N'2023-10-11T10:24:32.3133333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ac97747b-ae84-4916-2325-08dbca099599', 3, N'Section 3', 0, N'c538b99b-f724-4788-879f-adfe3b1a90ea', CAST(N'2023-10-11T10:35:18.5500000' AS DateTime2), CAST(N'2023-10-11T10:35:18.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'760cd38c-a1cc-4210-4f68-08dbd1dd90e7', 0, N'Before we Start', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ceb468c6-67a0-4ee0-4f69-08dbd1dd90e7', 1, N'Essential C and C++ Concepts', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4bf0b990-59fe-4541-4f6a-08dbd1dd90e7', 2, N'Required Setup for Programming', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e7e14d73-486e-4970-4f6b-08dbd1dd90e7', 3, N'Introduction', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'58918320-a3da-4058-4f6c-08dbd1dd90e7', 4, N'Recursion', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8458997b-ced6-4981-4f6d-08dbd1dd90e7', 5, N'Arrays Representations', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9c267f26-11d9-4b50-4f6e-08dbd1dd90e7', 6, N'Array ADT', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'55d5c768-5351-4954-4f6f-08dbd1dd90e7', 7, N'Strings', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e01d008c-4334-49c7-4f70-08dbd1dd90e7', 8, N'Matrices', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'370728d7-018d-4980-4f71-08dbd1dd90e7', 9, N'Sparse Matrix and Polynomial Representation', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bfda0f8d-67ff-4bcc-4f72-08dbd1dd90e7', 10, N'Linked List', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'44168d14-0286-48eb-4f73-08dbd1dd90e7', 11, N'Sparse Matrix and Polynomial using Linked List', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3f75e7e8-e593-4aaa-4f74-08dbd1dd90e7', 12, N'Stack', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cb0902fd-6660-4dd2-4f75-08dbd1dd90e7', 13, N'Queues', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'728801f1-d39a-43a8-4f76-08dbd1dd90e7', 14, N'Trees', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'362a1739-6214-4a50-4f77-08dbd1dd90e7', 15, N'Binary Search Trees', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'22ea80a9-0abf-4775-4f78-08dbd1dd90e7', 16, N'AVL Trees', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7d9dc073-d9fb-4e36-4f79-08dbd1dd90e7', 17, N'Search Trees', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'67d6bca4-079c-4131-4f7a-08dbd1dd90e7', 18, N'Heap', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bb99d692-7852-434c-4f7b-08dbd1dd90e7', 19, N'Sorting Techniques', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3c4cf3bb-805b-4877-4f7c-08dbd1dd90e7', 20, N'Hashing Technique', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3b2ee561-32a6-41f4-4f7d-08dbd1dd90e7', 21, N'Graphs', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'eb2830da-d786-4851-4f7e-08dbd1dd90e7', 22, N'Asymptotic Notations', 0, N'dc049cd3-f74d-4e0b-b898-6258c7c89606', CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2), CAST(N'2023-10-21T09:29:35.5500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3f88bd06-c793-449e-4f7f-08dbd1dd90e7', 0, N'Introduction', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'79b8cd46-f677-431d-4f80-08dbd1dd90e7', 1, N'Getting More Interviews', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2d115480-86c1-49f9-4f81-08dbd1dd90e7', 2, N'Big O', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'01268ddb-4e7b-46a5-4f82-08dbd1dd90e7', 3, N'How To Solve Coding Problems', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4bccb314-91b8-4e38-4f83-08dbd1dd90e7', 4, N'Data Structures: Introduction', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'926042e9-86df-456e-4f84-08dbd1dd90e7', 5, N'Data Structures: Arrays', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'18a20e7e-2466-434c-4f85-08dbd1dd90e7', 6, N'Data Structures: Hash Tables', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c211e74d-0e22-4fbe-4f86-08dbd1dd90e7', 7, N'Data Structures: Linked Lists', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8a2f3f90-29f8-49ef-4f87-08dbd1dd90e7', 8, N'Data Structures: Stacks + Queues', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'debdf884-b492-4c1e-4f88-08dbd1dd90e7', 9, N'Data Structures: Trees', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dec80c16-2525-4bf7-4f89-08dbd1dd90e7', 10, N'Data Structures: Graphs', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd0c26633-97ed-495a-4f8a-08dbd1dd90e7', 11, N'Algorithms: Recursion', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8ffe5a92-384b-41e4-4f8b-08dbd1dd90e7', 12, N'Algorithms: Sorting', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'325bc456-5f02-4d6b-4f8c-08dbd1dd90e7', 13, N'Algorithms: Searching + BFS + DFS', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'73315a9e-4b1f-42dd-4f8d-08dbd1dd90e7', 14, N'Algorithms: Dynamic Programming', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'66baebb8-9961-4c5e-4f8e-08dbd1dd90e7', 15, N'Non Technical Interviews', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e42a2713-e4f2-48ef-4f8f-08dbd1dd90e7', 16, N'Offer + Negotiation', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ada3e9b1-3e08-49e8-4f90-08dbd1dd90e7', 17, N'Thank You', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'615e332d-c505-492e-4f91-08dbd1dd90e7', 18, N'Extras: Google, Amazon, Facebook Interview Questions', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b9c5b460-25ea-44e9-4f92-08dbd1dd90e7', 19, N'Contributing To Open Source To Gain Experience', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fa38a02c-0447-45dc-4f93-08dbd1dd90e7', 20, N'Extra Bits', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'979e53ab-ac5b-49cf-4f94-08dbd1dd90e7', 21, N'BONUS SECTION', 0, N'306907db-8f36-4c56-a6e5-14ad3c4979e2', CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2), CAST(N'2023-10-21T09:29:35.8266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cdc64842-9689-40ec-4f95-08dbd1dd90e7', 0, N'Introduction', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'272367f2-7af3-48e7-4f96-08dbd1dd90e7', 1, N'Getting Started', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9a2d907f-527f-4c2d-4f97-08dbd1dd90e7', 2, N'Managing Documents', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2c63dfc6-c938-4664-4f98-08dbd1dd90e7', 3, N'Mapping & Analysis', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ac63b62a-c865-48b1-4f99-08dbd1dd90e7', 4, N'Searching for Data', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'627b10ff-bc19-4138-4f9a-08dbd1dd90e7', 5, N'Joining Queries', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e952aa53-a0ed-4673-4f9b-08dbd1dd90e7', 6, N'Controlling Query Results', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'35203405-f2b8-4fd3-4f9c-08dbd1dd90e7', 7, N'Aggregations', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'30db606e-0d51-4431-4f9d-08dbd1dd90e7', 8, N'Improving Search Results', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c150dbf0-55fc-46d4-4f9e-08dbd1dd90e7', 9, N'Conclusion', 0, N'f77d812a-8569-4367-aaee-62ee7a1a2238', CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2), CAST(N'2023-10-21T09:29:35.9700000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'318406e9-2226-43f7-4f9f-08dbd1dd90e7', 0, N'Introduction', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2c2a1e96-ab87-478f-4fa0-08dbd1dd90e7', 1, N'Single Responsibility Principle', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'aae0634a-fca0-45f8-4fa1-08dbd1dd90e7', 2, N'Open Closed Principle', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9dc44a00-734e-4b93-4fa2-08dbd1dd90e7', 3, N'Liskov Substitution Principle', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'78182df8-8346-48b5-4fa3-08dbd1dd90e7', 4, N'Interface Segregation Principle', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b17e7799-8dec-4015-4fa4-08dbd1dd90e7', 5, N'Dependency Inversion Principle', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'68477b46-3c75-45bd-4fa5-08dbd1dd90e7', 6, N'Course Summary', 0, N'eb218df6-0f81-40a0-890b-aacff717e76d', CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2), CAST(N'2023-10-21T09:29:36.0933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd27738d7-8fc0-413e-4fa6-08dbd1dd90e7', 0, N'Course Introduction', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'79f4034e-658e-4ac1-4fa7-08dbd1dd90e7', 1, N'SQL Statement Fundamentals', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'323a6079-d785-4c5f-4fa8-08dbd1dd90e7', 2, N'GROUP BY Statements', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'19d7cf7d-f5b3-46e3-4fa9-08dbd1dd90e7', 3, N'Assessment Test 1', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'05cdd41e-c048-43c9-4faa-08dbd1dd90e7', 4, N'JOINS', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6c2b57bf-f6ea-4323-4fab-08dbd1dd90e7', 5, N'Advanced SQL Commands', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'77272008-2e83-46a0-4fac-08dbd1dd90e7', 6, N'Assessment Test 2', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cc188ec8-7795-44aa-4fad-08dbd1dd90e7', 7, N'Creating Databases and Tables', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2496e486-c83e-44e9-4fae-08dbd1dd90e7', 8, N'Assessment Test 3', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7754332d-5490-4e41-4faf-08dbd1dd90e7', 9, N'Conditional Expressions and Procedures', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'247b063d-ac60-4987-4fb0-08dbd1dd90e7', 10, N'Extra: PostGreSQL with Python', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4ce6b43f-f5ea-4eee-4fb1-08dbd1dd90e7', 11, N'BONUS SECTION: THANK YOU!', 0, N'22ab70da-adac-4aa2-b03e-2becbf29ea56', CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2), CAST(N'2023-10-21T09:29:36.1966667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'074d8fa1-5b7a-43ff-4fb2-08dbd1dd90e7', 0, N'Getting Started', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6733e2fa-0337-4977-4fb3-08dbd1dd90e7', 1, N'Introducing Microsoft Power BI Desktop', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4f302361-46b6-49cd-4fb4-08dbd1dd90e7', 2, N'Connecting & Shaping Data', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'26bf4e87-40c2-4242-4fb5-08dbd1dd90e7', 3, N'Creating a Data Model', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4eea8a6b-a9c2-477b-4fb6-08dbd1dd90e7', 4, N'Calculated Fields with DAX', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7881e946-45e3-4437-4fb7-08dbd1dd90e7', 5, N'Visualizing Data with Reports', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bf2519ef-7848-434a-4fb8-08dbd1dd90e7', 6, N'Artificial Intelligence (AI)', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'23919bc3-9731-4d87-4fb9-08dbd1dd90e7', 7, N'Power BI Optimization Tools', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd6437fbc-15e9-423b-4fba-08dbd1dd90e7', 8, N'BONUS PROJECT: Maven Market', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4320c126-53fb-490b-4fbb-08dbd1dd90e7', 9, N'BONUS LESSON', 0, N'c05e0a8e-1751-4cf0-a3fb-2b41437987ea', CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2), CAST(N'2023-10-21T09:29:36.3233333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1e193af4-f1bf-440e-4fbc-08dbd1dd90e7', 0, N'It''s super easy to get Started', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'da05f01f-26ea-4e5b-4fbd-08dbd1dd90e7', 1, N'Tableau Basics: Your First Bar chart', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4a2059f3-4c71-4e81-4fbe-08dbd1dd90e7', 2, N'Time series, Aggregation, and Filters', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6779c66d-07c2-46dc-4fbf-08dbd1dd90e7', 3, N'Maps, Scatterplots, and Your First Dashboard', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b8920d2b-1151-4fc0-4fc0-08dbd1dd90e7', 4, N'Joining, Blending and Relationships; PLUS: Dual Axis Charts', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4376a693-45b8-4133-4fc1-08dbd1dd90e7', 5, N'Table Calculations, Advanced Dashboards, Storytelling', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c564caab-d92c-4e5c-4fc2-08dbd1dd90e7', 6, N'Advanced Data Preparation', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'496da2a6-4847-4032-4fc3-08dbd1dd90e7', 7, N'Clusters, Custom Territories, Design Features', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2f38f51a-5a9a-40fe-4fc4-08dbd1dd90e7', 8, N'What''s new in Tableau', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0ce3c270-ffdd-44d7-4fc5-08dbd1dd90e7', 9, N'Conclusion', 0, N'c144e470-4447-4ae7-8878-c6059a24888b', CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2), CAST(N'2023-10-21T09:29:36.4266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'11b2b327-ed9c-4205-4fc6-08dbd1dd90e7', 0, N'Getting Started', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd14f23c2-24cc-4366-4fc7-08dbd1dd90e7', 1, N'Understanding the Power BI Desktop Basics & Preparing the Course Project', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'67820551-eb3a-48a3-4fc8-08dbd1dd90e7', 2, N'Data Preparation in the Power Query Editor', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9b73ea99-3d17-4444-4fc9-08dbd1dd90e7', 3, N'Data Transformation in the Power Query Editor', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1068521b-b080-41e7-4fca-08dbd1dd90e7', 4, N'The Data Model: Working with Relationships & DAX (Data Analysis Espressions)', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'76bd43d6-796f-49ac-4fcb-08dbd1dd90e7', 5, N'Creating Visuals in the Report View', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ea14f09b-75d9-4986-4fcc-08dbd1dd90e7', 6, N'Power BI Pro & Mobile: Sharing & Collaborating with Workspaces & Apps', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'27f9d605-5053-43bc-4fcd-08dbd1dd90e7', 7, N'Other Data Sources', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'08ef40a8-5cdf-4af0-4fce-08dbd1dd90e7', 8, N'How to Stay Up-to-Date in the Power BI World?', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'849b8af8-6c81-423f-4fcf-08dbd1dd90e7', 9, N'Course Round Up', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e30e814c-64fe-4d33-4fd0-08dbd1dd90e7', 10, N'Optional: Power BI Desktop Crash Course / Introduction & Summary', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3d858306-fe05-4b59-4fd1-08dbd1dd90e7', 11, N'Bonus: Selected Features by Example & Refresher Project', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'28d52655-a9ea-413d-4fd2-08dbd1dd90e7', 12, N'This Course Was Completely Updated', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'483790be-bdf1-465e-4fd3-08dbd1dd90e7', 13, N'Course Roundup', 0, N'3a4d7856-9d28-4944-8b47-bb2ab1d862cd', CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2), CAST(N'2023-10-21T09:29:36.4500000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'43a4017d-b0fd-4e48-4fd4-08dbd1dd90e7', 0, N'Introduction to databases, SQL, and MySQL', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e761e600-f2a5-4c8a-4fd5-08dbd1dd90e7', 1, N'SQL theory', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9887ab38-5ea5-473c-4fd6-08dbd1dd90e7', 2, N'Basic database terminology', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6d56833f-92d5-4fa9-4fd7-08dbd1dd90e7', 3, N'Installing MySQL and getting acquainted with the interface', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'675adf59-7026-44bd-4fd8-08dbd1dd90e7', 4, N'First steps in SQL', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ecd1c35f-a264-43d4-4fd9-08dbd1dd90e7', 5, N'MySQL constraints', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f085e1a0-546c-4979-4fda-08dbd1dd90e7', 6, N'SQL best practices', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'89ba4605-6a6f-4a7a-4fdb-08dbd1dd90e7', 7, N'Loading the ''employees'' database', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2b3376b7-89b0-4e1b-4fdc-08dbd1dd90e7', 8, N'SQL SELECT statement', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'40773cf6-82b6-41d8-4fdd-08dbd1dd90e7', 9, N'SQL INSERT statement', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'54e0adc5-ae2b-4e6f-4fde-08dbd1dd90e7', 10, N'SQL UPDATE Statement', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9c7a36c4-8737-4cf4-4fdf-08dbd1dd90e7', 11, N'SQL DELETE Statement', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b74cf9c4-6fc7-4d74-4fe0-08dbd1dd90e7', 12, N'MySQL - Aggregate functions', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e39b268b-9432-4661-4fe1-08dbd1dd90e7', 13, N'SQL Joins', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8032fbd6-bfa6-44cb-4fe2-08dbd1dd90e7', 14, N'SQL Subqueries', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'269cfe01-97d6-4466-4fe3-08dbd1dd90e7', 15, N'SQL Self Join', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f672c61e-943d-4c8c-4fe4-08dbd1dd90e7', 16, N'SQL Views', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'238df871-d77a-4963-4fe5-08dbd1dd90e7', 17, N'Stored routines', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f2bf6e0e-66b3-4f18-4fe6-08dbd1dd90e7', 18, N'Advanced SQL Topics', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9c2bc52a-0ed8-4e94-4fe7-08dbd1dd90e7', 19, N'SQL Window Functions', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c20a9d54-2957-4f2d-4fe8-08dbd1dd90e7', 20, N'SQL Common Table Expressions (CTEs)', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fbed11a7-a293-4c80-4fe9-08dbd1dd90e7', 21, N'SQL Temporary Tables', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c48f39a4-8537-4f33-4fea-08dbd1dd90e7', 22, N'Combining SQL and Tableau - Introduction', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e90dfe3c-95c0-441f-4feb-08dbd1dd90e7', 23, N'Combining SQL and Tableau - Task 1', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6183aed0-1c82-40ea-4fec-08dbd1dd90e7', 24, N'Combining SQL and Tableau - Task 2', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'06141eca-b270-4281-4fed-08dbd1dd90e7', 25, N'Combining SQL and Tableau - Task 3', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b2572a75-efb9-4749-4fee-08dbd1dd90e7', 26, N'Combining SQL and Tableau - Task 4', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3e7199a4-a18c-4e2c-4fef-08dbd1dd90e7', 27, N'Combining SQL and Tableau - Task 5', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5f5a67ce-7a77-41ea-4ff0-08dbd1dd90e7', 28, N'Practice SQL – 10 Final Query Questions', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c93d1c4b-118c-41f5-4ff1-08dbd1dd90e7', 29, N'BONUS LECTURE', 0, N'8e4a122d-62fa-43c2-b2c2-a58053447f33', CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2), CAST(N'2023-10-21T09:29:36.5533333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f19b04ba-b441-4b92-4ff2-08dbd1dd90e7', 0, N'Welcome to the Course!', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1813a4a9-fe52-4029-4ff3-08dbd1dd90e7', 1, N'The Basics', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6fa70de4-f425-4e1f-4ff4-08dbd1dd90e7', 2, N'Software Development Lifecycles (SDLC)', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a68ce3c5-9324-4c2a-4ff5-08dbd1dd90e7', 3, N'Initiating a Project', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'275c4372-214d-465d-4ff6-08dbd1dd90e7', 4, N'Requirement Basics', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1fa78a45-fd74-491b-4ff7-08dbd1dd90e7', 5, N'Requirement Elicitation', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1324063a-d46d-4fd5-4ff8-08dbd1dd90e7', 6, N'Requirement Analysis', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd34780d3-cf9f-4370-4ff9-08dbd1dd90e7', 7, N'Requirement Specification', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'37b4283d-98ac-4226-4ffa-08dbd1dd90e7', 8, N'Requirements Approval', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9091f288-d9fd-42ef-4ffb-08dbd1dd90e7', 9, N'After the Project', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c167d9e7-9636-4187-4ffc-08dbd1dd90e7', 10, N'Miscellaneous Other Topics', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f83046dc-394e-4b1a-4ffd-08dbd1dd90e7', 11, N'Bonus Section', 0, N'ec6bada9-dac8-4f3f-9660-3a9d5948def5', CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2), CAST(N'2023-10-21T09:29:36.6733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'43aa5891-d39b-4ebe-4ffe-08dbd1dd90e7', 0, N'Introduction', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'32d3a07c-8b0e-4943-4fff-08dbd1dd90e7', 1, N'Introduction to Unconscious Bias', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'be3abbb5-d14c-462d-5000-08dbd1dd90e7', 2, N'Types of Unconscious Bias', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a8eadfc5-8037-45ff-5001-08dbd1dd90e7', 3, N'What''s the Negative Impact of Unconscious Bias?', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'14dd00ed-b2e4-49b0-5002-08dbd1dd90e7', 4, N'Combat Unconscious Bias', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cb035c66-09c0-44e3-5003-08dbd1dd90e7', 5, N'How Do You Know It''s Working?', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'06060b0e-df44-47c6-5004-08dbd1dd90e7', 6, N'Create Your Own Story', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0fed0cde-b01d-4bed-5005-08dbd1dd90e7', 7, N'Keep Improving', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'047bc8e2-f4eb-4834-5006-08dbd1dd90e7', 8, N'Coronavirus and Unconscious Bias', 0, N'3863939b-6d0a-4f0f-82a6-c029bcdfccc5', CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2), CAST(N'2023-10-21T09:29:36.8033333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e08a766e-97cb-46b6-5007-08dbd1dd90e7', 0, N'Introduction to Emotionally Intelligent Team Working', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'10f8acc7-8dd0-4d46-5008-08dbd1dd90e7', 1, N'Practical Activities - Assessing your Team', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd6fce7f6-580d-44ba-5009-08dbd1dd90e7', 2, N'What is Emotional Intelligence?', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e37ffc38-8b40-403a-500a-08dbd1dd90e7', 3, N'Change Management', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fc25663e-f780-441d-500b-08dbd1dd90e7', 4, N'Conflict in Teamwork', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'496b1c1a-6c50-4828-500c-08dbd1dd90e7', 5, N'Working with Others in a Team', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6b0b9fb8-84e9-47c4-500d-08dbd1dd90e7', 6, N'DISC Quiz', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd4eed96c-914c-4262-500e-08dbd1dd90e7', 7, N'The Emotional Resilience of Teams', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'57147e2d-23ac-4373-500f-08dbd1dd90e7', 8, N'Conclusion to the Course', 0, N'bf17dbaa-5185-4b03-a559-06ce94607ad5', CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2), CAST(N'2023-10-21T09:29:36.9066667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ff5d8c0c-1aa3-4590-5010-08dbd1dd90e7', 0, N'Introduction to Conflict Management with Emotional Intelligence', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1bc8e2b3-eac4-4029-5011-08dbd1dd90e7', 1, N'What is Conflict?', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'08473847-c25b-4b70-5012-08dbd1dd90e7', 2, N'Practical Activity - Exploring Conflict', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0dd67aeb-cc7b-40e3-5013-08dbd1dd90e7', 3, N'Assertiveness', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1bea3ae1-da1b-4d97-5014-08dbd1dd90e7', 4, N'Practical Activity - Assertiveness', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'73e61ac9-1294-4325-5015-08dbd1dd90e7', 5, N'Managing Toxic Situations More Effectively', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c6afd2e0-574b-4e78-5016-08dbd1dd90e7', 6, N'Practical Activity - Toxic Situations', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3fa35992-84f0-4898-5017-08dbd1dd90e7', 7, N'Emotional Intelligence and Conflict', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'969d9568-19c7-4446-5018-08dbd1dd90e7', 8, N'The Chimp Paradox', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b404fb48-5e20-4be4-5019-08dbd1dd90e7', 9, N'Practical Activity - Chimp Reactions and Human Emotions', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b86156a3-247a-4d5e-501a-08dbd1dd90e7', 10, N'The Five Modes of Conflict Management', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5f2a4f75-1dc8-4be2-501b-08dbd1dd90e7', 11, N'The Importance of Flexibility in Conflict', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2bf4f903-5d43-4713-501c-08dbd1dd90e7', 12, N'Practical Activity - Assess and Focus on How you Use your Time Preference', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b93868ee-6405-4a14-501d-08dbd1dd90e7', 13, N'Some Ways That You Can Work to Resolve Conflict', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1781a0cd-f454-4d4b-501e-08dbd1dd90e7', 14, N'Conclusion to the Course', 0, N'e47f4b22-1cd0-42f8-a1f0-6405eff3d980', CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2), CAST(N'2023-10-21T09:29:36.9400000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'42ed6fa0-a083-4e09-501f-08dbd1dd90e7', 0, N'Sexual Harassment Explained', 0, N'7f1e0959-2530-4367-941e-ae1b1e99bdc1', CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e873c306-d101-419b-5020-08dbd1dd90e7', 1, N'Identifying Sexual Harassment in the Workplace', 0, N'7f1e0959-2530-4367-941e-ae1b1e99bdc1', CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7cf8d849-d008-4d4c-5021-08dbd1dd90e7', 2, N'Reporting and Preventing Sexual Harassment', 0, N'7f1e0959-2530-4367-941e-ae1b1e99bdc1', CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.0266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'abe33d74-4a28-4ed3-5022-08dbd1dd90e7', 0, N'The Essentials', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2924941a-775b-4e3b-5023-08dbd1dd90e7', 1, N'Building Out Your Shopify store', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'31467960-7ee0-4c0f-5024-08dbd1dd90e7', 2, N'Choosing Your Market And Deciding What To sell', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a1dc3a07-8363-461f-5025-08dbd1dd90e7', 3, N'Adding Products', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4edbdbda-5c20-4feb-5026-08dbd1dd90e7', 4, N'Now It Gets Exciting - Time To Build A Real Business !', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ff805047-323c-4d23-5027-08dbd1dd90e7', 5, N'Your First $10K - Getting Started', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'71995ecf-ef8b-4935-5028-08dbd1dd90e7', 6, N'Your First $10K - Your Store - Taking It To The Next Level', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'31eb5784-6772-488f-5029-08dbd1dd90e7', 7, N'Your First $10K - Your Store - Speed', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e289f7cf-82bf-4f15-502a-08dbd1dd90e7', 8, N'Your First $10K - Your Store - Customer Service', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'eb2b42d8-7cd6-41a4-502b-08dbd1dd90e7', 9, N'Your First $10K - Products - Finding Reliable Suppliers', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'949458b4-a72f-40b7-502c-08dbd1dd90e7', 10, N'Your First $10K - Products - Fast & Affordable Shipping', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cdfe27a9-e7c9-461c-502d-08dbd1dd90e7', 11, N'Your First $10K - Driving Traffic - Your Ideal Customer', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a8b92cc4-7b7f-4314-502e-08dbd1dd90e7', 12, N'Your First $10K - Driving Traffic  - Let''s Get Ready!', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5f33fadb-144e-403c-502f-08dbd1dd90e7', 13, N'Your First $10K - Driving Traffic  -  Easy FREE Wins!', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a9b720a3-7072-480b-5030-08dbd1dd90e7', 14, N'Your First $10K - Driving Traffic - Easy AFFORDABLE Wins!', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8f09babf-eae3-44be-5031-08dbd1dd90e7', 15, N'Your First $10K - Driving Traffic - Paid Ads and the Perfect Strategy', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b919acd0-d145-4670-5032-08dbd1dd90e7', 16, N'Preparing For Sales', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd2cec7c3-e15d-4df7-5033-08dbd1dd90e7', 17, N'Making Sales', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'beda6f8a-534e-4e2c-5034-08dbd1dd90e7', 18, N'Beyond $10K/month - Boosting Your Sales', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'64dc8116-eab4-4b3c-5035-08dbd1dd90e7', 19, N'Beyond $10K/month - Going International', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e9d76a7a-2963-4b9f-5036-08dbd1dd90e7', 20, N'Beyond $10K/month - Running Your Business', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f261bf6e-22f6-46b7-5037-08dbd1dd90e7', 21, N'The Sky''s The Limit', 0, N'7393d558-f75b-4157-8e59-6ce79f779649', CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2), CAST(N'2023-10-21T09:29:37.1266667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'79ff18e0-e5b0-4eb3-5038-08dbd1dd90e7', 0, N'Introduction', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a75ee05f-7eb9-467e-5039-08dbd1dd90e7', 1, N'Choosing Niches and Products', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4b80f901-217d-47e7-503a-08dbd1dd90e7', 2, N'Setting up Your Drop Ship Store', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'77afde55-f0c8-4f09-503b-08dbd1dd90e7', 3, N'Finding Suppliers to Drop Ship for You', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5efa8e8c-1f73-4f04-503c-08dbd1dd90e7', 4, N'Make Your Store ''Rock''!', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4b1b7ca5-1030-43fb-503d-08dbd1dd90e7', 5, N'Launch and Kick Start Your New Store', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e765b693-c6d6-4170-503e-08dbd1dd90e7', 6, N'Drop Shipping from AliExpress and Banggood', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd2a56374-1800-43cd-503f-08dbd1dd90e7', 7, N'Important Lessons and Resources', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b23b7d70-d7ce-4be8-5040-08dbd1dd90e7', 8, N'Store Critiques', 0, N'bcb4c3e5-6e1c-4773-a925-6291222344ab', CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2), CAST(N'2023-10-21T09:29:37.4466667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5faa9369-691e-4fa8-5041-08dbd1dd90e7', 0, N'Picking Up ChatGPT', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7527f2b9-62fe-45c2-5042-08dbd1dd90e7', 1, N'Workshops for Business Owners and Advanced Prompt Engineering', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0252d51d-06fb-4a76-5043-08dbd1dd90e7', 2, N'Build, Optimize, and Scale your Business Using ChatGPT', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'525c1d28-002e-4881-5044-08dbd1dd90e7', 3, N'Learn how to use the ChatGPT API', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd3521679-4c6a-4e7a-5045-08dbd1dd90e7', 4, N'Learn Python in Real Time: Zero to Hero Python Course: UPDATED WEEKLY', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'067834ed-8663-4025-5046-08dbd1dd90e7', 5, N'ChatGPT Deep Dives Updated Weekly!', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'95606b30-2941-4e83-5047-08dbd1dd90e7', 6, N'ChatGPT for Students', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2373772e-7998-479c-5048-08dbd1dd90e7', 7, N'The Full Power of ChatGPT: Odds and Ends + Protips', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'04cc961b-1f7f-420d-5049-08dbd1dd90e7', 8, N'Beyond GPT: The Best Tools and Plug ins using AI', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'364628e4-3ca4-48b1-504a-08dbd1dd90e7', 9, N'Create Incredible Art with Dall-E 2', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'31b784d2-3dc4-4249-504b-08dbd1dd90e7', 10, N'Basic Programming with ChatGPT', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3d40f125-46ea-4368-504c-08dbd1dd90e7', 11, N'Advanced Programming with ChatGPT in Javascript', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'22420956-5d84-48c6-504d-08dbd1dd90e7', 12, N'Learn From Other Members of the ChatGPT Community!', 0, N'9fed7922-71ef-404b-b105-a58c9d8a8c12', CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:37.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd26f8e2b-e81c-4110-504e-08dbd1dd90e7', 0, N'Introduction', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6d9dd659-9fba-436d-504f-08dbd1dd90e7', 1, N'Let''s Start Building!', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'21568942-d2f3-44eb-5050-08dbd1dd90e7', 2, N'Time To Start Building A Real Business!', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'db772830-2077-4edc-5051-08dbd1dd90e7', 3, N'Ecommerce - Building Your Store', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dfb940ba-ed43-489d-5052-08dbd1dd90e7', 4, N'Ecommerce - Time To Checkout!', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'915b41a1-f79a-48af-5053-08dbd1dd90e7', 5, N'Apps', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a96bae76-8b36-4a99-5054-08dbd1dd90e7', 6, N'Where To Now - The Sky''s The Limit!', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ea0b38e0-2c8e-4988-5055-08dbd1dd90e7', 7, N'Bonus Section', 0, N'079bf045-403c-458d-8a9f-74015888c191', CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2), CAST(N'2023-10-21T09:29:37.7200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'367fe647-178a-4580-5056-08dbd1dd90e7', 0, N'Introduction', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'aba7b9b8-8eef-4802-5057-08dbd1dd90e7', 1, N'Setting up a Hacking Lab', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f2fd5fdf-c120-4ba7-5058-08dbd1dd90e7', 2, N'Linux Basics', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'146c6fa6-8777-4bb8-5059-08dbd1dd90e7', 3, N'Network Hacking', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'13e5c1f8-26e0-4f9e-505a-08dbd1dd90e7', 4, N'Network Hacking - Pre Connection Attacks', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'31afaa2e-cf65-4ec8-505b-08dbd1dd90e7', 5, N'Network Hacking - Gaining Access - WEP Cracking', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1392041e-9bd5-461e-505c-08dbd1dd90e7', 6, N'Network Hacking - Gaining Access - WPA / WPA2 Cracking', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e4ee380d-9128-4f71-505d-08dbd1dd90e7', 7, N'Network Hacking - Gaining Access - Security', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9e4f8d1e-db86-47e4-505e-08dbd1dd90e7', 8, N'Network Hacking - Post Connection Attacks', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'728b9dc0-e758-4ad6-505f-08dbd1dd90e7', 9, N'Network Hacking - Post-Connection Attacks - Information Gathering', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'099c6208-721f-4f19-5060-08dbd1dd90e7', 10, N'Network Hacking - Post Connection Attacks - MITM Attacks', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3e8b5ac4-588a-4afe-5061-08dbd1dd90e7', 11, N'Network Hacking - Detection & Security', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9f5378e0-a4b1-4000-5062-08dbd1dd90e7', 12, N'Gaining Access To Computers', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'78f7331d-3a6d-4720-5063-08dbd1dd90e7', 13, N'Gaining Access - Server Side Attacks', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8a516829-daaf-40cd-5064-08dbd1dd90e7', 14, N'Gaining Access - Client Side Attacks', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'dfc461e3-d77a-4b5f-5065-08dbd1dd90e7', 15, N'Gaining Access - Client Side Attacks - Social Engineering', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4fb70021-b78a-4ec8-5066-08dbd1dd90e7', 16, N'Gaining Access - Using The Above Attacks Outside The Local Network', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cb34026e-77df-49fd-5067-08dbd1dd90e7', 17, N'Post Exploitation', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'71033d0b-4430-4b41-5068-08dbd1dd90e7', 18, N'Website Hacking', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'57e1c7d7-9238-4da1-5069-08dbd1dd90e7', 19, N'Website Hacking - Information Gathering', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'109632f9-0e4d-4e1b-506a-08dbd1dd90e7', 20, N'Website Hacking - File Upload, Code Execution & File Inclusion Vulns', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f2bc6959-444b-4d95-506b-08dbd1dd90e7', 21, N'Website Hacking - SQL Injection Vulnerabilities', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'74da707f-7e7f-4680-506c-08dbd1dd90e7', 22, N'Website Hacking -  Cross Site Scripting Vulnerabilities', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'04deb339-3b63-402c-506d-08dbd1dd90e7', 23, N'Website Hacking - Discovering Vulnerabilities Automatically', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fec6e317-d486-42f9-506e-08dbd1dd90e7', 24, N'Bonus Section', 0, N'c4bf0666-642f-47c8-a2eb-2f7b9c281f96', CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2), CAST(N'2023-10-21T09:29:37.8600000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4292276e-42a8-43aa-506f-08dbd1dd90e7', 0, N'Introduction', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'54154d63-31cc-4e31-5070-08dbd1dd90e7', 1, N'Kubernetes Overview', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bc95c356-8bf9-41ba-5071-08dbd1dd90e7', 2, N'Kubernetes Concepts', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fa809c10-e4e5-4f12-5072-08dbd1dd90e7', 3, N'YAML Introduction', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cbe064f3-82ad-4e7d-5073-08dbd1dd90e7', 4, N'Kubernetes Concepts - Pods, ReplicaSets, Deployments', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0ad93b14-76f8-476a-5074-08dbd1dd90e7', 5, N'Networking in Kubernetes', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5f9587d7-273d-446f-5075-08dbd1dd90e7', 6, N'Services', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'77424570-892a-4ed5-5076-08dbd1dd90e7', 7, N'Microservices Architecture', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6c953457-9274-48ae-5077-08dbd1dd90e7', 8, N'Kubernetes on Cloud', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'edfd6bdc-4f5b-417a-5078-08dbd1dd90e7', 9, N'Conclusion', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'133526ca-180e-4214-5079-08dbd1dd90e7', 10, N'Appendix - Setup Multi Node cluster using Kubeadm', 0, N'54155f7f-e41e-48f5-bcea-1181c8918c32', CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2), CAST(N'2023-10-21T09:29:37.9900000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4611b78c-4f95-466b-507a-08dbd1dd90e7', 0, N'Introduction', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'05fe67f4-df9b-4f10-507b-08dbd1dd90e7', 1, N'know Yourself - The Threat and Vulnerability Landscape', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'88ff9976-4371-4e5b-507c-08dbd1dd90e7', 2, N'Know Your Enemy  - The Current Threat and Vulnerability Landscape', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2ab5993b-a3d9-4597-507d-08dbd1dd90e7', 3, N'Encryption Crash Course', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'07b40480-70e1-4cbe-507e-08dbd1dd90e7', 4, N'Setting up a Testing Environment Using Virtual Machines (Lab)', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'38e75b82-5949-4a6e-507f-08dbd1dd90e7', 5, N'Operating System Security & Privacy (Windows vs Mac OS X vs Linux)', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f7e843e6-545d-4130-5080-08dbd1dd90e7', 6, N'Security Bugs and Vulnerabilities', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ae53c4ba-456e-48a4-5081-08dbd1dd90e7', 7, N'Reducing Threat Privilege', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'73bd29bc-d9ad-4084-5082-08dbd1dd90e7', 8, N'Social Engineering and Social Media Offence and Defence', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5fa718a7-b22b-4a5f-5083-08dbd1dd90e7', 9, N'Security Domains', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f73bef30-ec63-4d94-5084-08dbd1dd90e7', 10, N'Security Through Isolation and Compartmentalization', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e42fba72-8884-4b7e-5085-08dbd1dd90e7', 11, N'Wrap Up', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'10dffc8a-698b-4e26-5086-08dbd1dd90e7', 12, N'BONUS Section', 0, N'fefc792a-910b-4885-8f16-1f011ed8cb19', CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.3933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'beb688cc-35ff-45b9-5087-08dbd1dd90e7', 0, N'Welcome to the Course', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'aea462b8-0491-4192-5088-08dbd1dd90e7', 1, N'General Introduction to IT & Cyber Security', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'543b3a40-0385-46d6-5089-08dbd1dd90e7', 2, N'Hackers - Who are They?', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'89b957e2-5dbc-4872-508a-08dbd1dd90e7', 3, N'Attacks', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'663a5a83-3105-498e-508b-08dbd1dd90e7', 4, N'Malware', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4b9cac22-2c0a-478e-508c-08dbd1dd90e7', 5, N'Defences', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'54c4e17e-b4b6-4bb8-508d-08dbd1dd90e7', 6, N'Cyber Security at the Work Place', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'828a0ed1-c8ad-458e-508e-08dbd1dd90e7', 7, N'Cyber Warfare and Cyber Attacks Against Companies', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'11706e45-0b12-4b33-508f-08dbd1dd90e7', 8, N'Extras and Conclusion', 0, N'cd32da91-5825-4842-bc9b-3fe9d5fa3e45', CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2), CAST(N'2023-10-21T09:29:38.5733333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e04c1289-a053-4107-5090-08dbd1dd90e7', 0, N'Overview', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'b5b841a2-1bb0-4360-5091-08dbd1dd90e7', 1, N'Day 1', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9f7b3c0e-9e18-44c4-5092-08dbd1dd90e7', 2, N'Day 2', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9d215d46-6166-4efa-5093-08dbd1dd90e7', 3, N'Day 3', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd09ae4d9-7db2-4d7b-5094-08dbd1dd90e7', 4, N'Day 4', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6933f34f-9e25-4b21-5095-08dbd1dd90e7', 5, N'Day 5', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e8080a49-c2bf-4277-5096-08dbd1dd90e7', 6, N'Addendum - Connecting to Linux Over the Network', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'02fb2f16-a34d-44e9-5097-08dbd1dd90e7', 7, N'Bonus', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'84e55d5b-e789-48dc-5098-08dbd1dd90e7', 8, N'Bonus - Slides', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'611a47a6-81fb-448d-5099-08dbd1dd90e7', 9, N'Videos Replaced by Updated Lectures', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8bbe3d51-72df-4209-509a-08dbd1dd90e7', 10, N'Bonus Section', 0, N'cfb0e398-5f54-4793-b1e2-87955920c6dc', CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2), CAST(N'2023-10-21T09:29:38.6933333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd3cb1b9a-2201-49c1-509b-08dbd1dd90e7', 0, N'Introduction', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'10172f2b-74d8-4a59-509c-08dbd1dd90e7', 1, N'Module 1 - Understanding Linux Concepts', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd96f6327-2b7c-4857-509d-08dbd1dd90e7', 2, N'Module 2 - Download, Install and Configure', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3631de1f-a2f7-4a9d-509e-08dbd1dd90e7', 3, N'Module 3 - System Access and File System', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'faba4ed5-c209-45ce-509f-08dbd1dd90e7', 4, N'Module 4 - Linux Fundamentals', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2f706bcd-618f-4474-50a0-08dbd1dd90e7', 5, N'Module 5 - System Administration', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5fe97fb0-3157-4d47-50a1-08dbd1dd90e7', 6, N'Module 6 - Shell Scripting', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c917237b-e410-4a58-50a2-08dbd1dd90e7', 7, N'Module 7 - Networking, Services, and System Updates', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4d76bfd8-6ff4-4a08-50a3-08dbd1dd90e7', 8, N'Module 8 - Disk Management and Run Levels', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'752e5002-a702-4c51-50a4-08dbd1dd90e7', 9, N'Module 9 - All About Resume', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bcaf5b2b-f33b-4b3c-50a5-08dbd1dd90e7', 10, N'Module 10 - All About Interview', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'86da7098-e8a4-4a58-50a6-08dbd1dd90e7', 11, N'Course Recap and Linux future', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8913bc4d-1787-44c4-50a7-08dbd1dd90e7', 12, N'Additional Resources', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c143f03a-f13e-4bcd-50a8-08dbd1dd90e7', 13, N'Bonus', 0, N'd0640ad0-f04c-44dd-af94-a2f52e521ec7', CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:38.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4fc1064a-0a95-454b-50a9-08dbd1dd90e7', 0, N'Introduction to the Command Line', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'94ecddf3-28b6-406c-50aa-08dbd1dd90e7', 1, N'Working with Files', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'380feaa6-ca03-461b-50ab-08dbd1dd90e7', 2, N'Viewing and Editing Files', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7fbaa418-a376-4e97-50ac-08dbd1dd90e7', 3, N'Help Yourself!', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a3c5b193-bda3-4e5a-50ad-08dbd1dd90e7', 4, N'Make your Own Commands', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bdabe295-e620-430e-50ae-08dbd1dd90e7', 5, N'echo "Congrats on Finishing the Course"', 0, N'd58c5d69-6b8c-4889-a225-dd2295000787', CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2), CAST(N'2023-10-21T09:29:38.9833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f8e52592-6dcd-4b25-50af-08dbd1dd90e7', 0, N'Overview', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1cf6e6f3-7a68-472c-50b0-08dbd1dd90e7', 1, N'Installing and Connecting to a Linux System', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fef96a0e-4e75-4877-50b1-08dbd1dd90e7', 2, N'Linux Fundamentals', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'96fc066a-6b7a-468d-50b2-08dbd1dd90e7', 3, N'Intermediate Linux Skills', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5801fa65-26db-4dab-50b3-08dbd1dd90e7', 4, N'The Linux Boot Process and System Logging', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6cfe9cb2-c22f-4d0d-50b4-08dbd1dd90e7', 5, N'Disk Management', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'148f784a-3f12-4326-50b5-08dbd1dd90e7', 6, N'LVM - The Logical Volume Manager', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a484f4cf-2b81-4b64-50b6-08dbd1dd90e7', 7, N'User Management', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'85fcf4fb-ba26-4004-50b7-08dbd1dd90e7', 8, N'Networking', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'47fe4d6c-a6b8-4cfc-50b8-08dbd1dd90e7', 9, N'Advanced Linux Permissions', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bdf28473-2568-44b9-50b9-08dbd1dd90e7', 10, N'Shell Scripting', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ef093639-695e-4b95-50ba-08dbd1dd90e7', 11, N'Advanced Command Line Skills - Command Line Kung Fu', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fdeea5b7-5f42-42b6-50bb-08dbd1dd90e7', 12, N'Extras', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'8009c754-f5ca-47e6-50bc-08dbd1dd90e7', 13, N'Summary', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'de472e71-2928-474c-50bd-08dbd1dd90e7', 14, N'Course Slides', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9d921135-8a22-48e7-50be-08dbd1dd90e7', 15, N'Bonus Section', 0, N'37bf24ab-a5a8-48d6-a6e9-6fba29c25580', CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2), CAST(N'2023-10-21T09:29:39.0833333' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a9024270-a55c-4501-50bf-08dbd1dd90e7', 0, N'Welcome to The Course!', 1, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c0f70bec-997d-4d42-50c0-08dbd1dd90e7', 1, N'Mastery Level 1: Setting up your Linux Virtual Machine', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'661f0ebd-bfa6-42b4-50c1-08dbd1dd90e7', 2, N'Mastery Level 2: Mastering The Linux Terminal', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'495d9f90-5859-4c72-50c2-08dbd1dd90e7', 3, N'Mastery Level 3: Mastering The Linux File System', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'04401566-658b-4fb3-50c3-08dbd1dd90e7', 4, N'Mastery Level 4: Mastering Task Automation and Scheduling', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4b8636ff-1be5-4142-50c4-08dbd1dd90e7', 5, N'Mastery Level 5: Mastering Open Source Software', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c9bf484f-8444-485c-50c5-08dbd1dd90e7', 6, N'Course Conclusion', 1, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4a7e13de-7b5e-4113-50c6-08dbd1dd90e7', 7, N'Appendix: Setting up your Linux Virtual Machine', 0, N'da90cb50-fd9a-490a-bf29-bc0aae901cc5', CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.2200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'27abbbe3-2008-4865-50c7-08dbd1dd90e7', 0, N'Background, Introduction, and Preparation.', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'763d650b-3347-4432-50c8-08dbd1dd90e7', 1, N'Files and Directories', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a1d2d9d1-4270-4227-50c9-08dbd1dd90e7', 2, N'Advanced Command Line Techniques', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3fc32c74-a771-4113-50ca-08dbd1dd90e7', 3, N'Summary', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1af74f19-920d-491d-50cb-08dbd1dd90e7', 4, N'Bonus', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1daea8fc-d606-42b6-50cc-08dbd1dd90e7', 5, N'Addendum - Connecting to a Linux Virtual Machine Over the Network', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f25d62ea-1bd4-4b1a-50cd-08dbd1dd90e7', 6, N'Videos Replaced by Updated Lectures', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9d1c52df-664b-426b-50ce-08dbd1dd90e7', 7, N'Bonus Section', 0, N'6daf1c2f-74fe-45be-bf32-8b8d9b2560a7', CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2), CAST(N'2023-10-21T09:29:39.3666667' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'62833dd0-e675-437f-50cf-08dbd1dd90e7', 0, N'The Purpose and Fundamentals of Life Coaching', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'2a53ea75-767c-4117-50d0-08dbd1dd90e7', 1, N'Developing Self-Awareness and Emotional IQ', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a6219251-88a5-4612-50d1-08dbd1dd90e7', 2, N'The Development and Deconstruction of Core Beliefs', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'56eeebf2-5dfc-4e5d-50d2-08dbd1dd90e7', 3, N'Core Values & Understanding Human Behaviour', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9db71b73-459c-46f8-50d3-08dbd1dd90e7', 4, N'Life Coaching Language and Communication Skills', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'580523fa-d1aa-4ec8-50d4-08dbd1dd90e7', 5, N'Relationship Principles and Winning With People', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'41d38580-070c-4d8f-50d5-08dbd1dd90e7', 6, N'A Structure for Client Work and Active Goal Setting', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bf8a7958-e926-4fa0-50d6-08dbd1dd90e7', 7, N'Basic Principles for Business Development and Growth', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bb20c491-b888-4ebc-50d7-08dbd1dd90e7', 8, N'The Seven-Stage Life Coaching Framework', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'bb07c85c-c82c-45c3-50d8-08dbd1dd90e7', 9, N'Q & A''s - Student Commonly Asked Questions', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6313e633-c5c4-4bd9-50d9-08dbd1dd90e7', 10, N'Compressing Your Knowledge and Course Graduation', 0, N'0a43fb00-d5d9-4fa8-8816-a2a08cfd9140', CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.4800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'cf513553-1437-4068-50da-08dbd1dd90e7', 0, N'Introduction Section', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'22fbedce-e3c9-4ea7-50db-08dbd1dd90e7', 1, N'Neurological Insights Into The Human Experience', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'5e2d5f8d-dd50-4938-50dc-08dbd1dd90e7', 2, N'Self-Awareness, Growth, Clarity and Goals', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'85f6dde3-b49c-4d76-50dd-08dbd1dd90e7', 3, N'A Practical Framework for Effective NLP Coaching', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a8df54c4-e8be-49bc-50de-08dbd1dd90e7', 4, N'NLP State and the Basis of Human Responses', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3449362c-61ef-498e-50df-08dbd1dd90e7', 5, N'The Wisdom of Virgina Satir, Fritz Perls & Milton H. Erickson', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'9de6f899-e246-448c-50e0-08dbd1dd90e7', 6, N'NLP Change Work Processes & Principles', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a45eabf2-d782-45f5-50e1-08dbd1dd90e7', 7, N'NLP Anchoring, Learning & Conditioned Behaviour', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f00dcfa9-6fb2-4c39-50e2-08dbd1dd90e7', 8, N'NLP Communication Skills & Language Patterns', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'76f830d0-7cc7-4142-50e3-08dbd1dd90e7', 9, N'NLP Strategies for Increasing Self-Effectiveness', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f3a0714c-965d-4f0e-50e4-08dbd1dd90e7', 10, N'Unpacking Core Human Values', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e0918978-5ade-46e0-50e5-08dbd1dd90e7', 11, N'End of Course Summary & Certification', 0, N'8999b164-da6b-4769-b65e-57860202e531', CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.5800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'd845c5ff-e5ee-4e76-50e6-08dbd1dd90e7', 0, N'FOUNDATION: Introduction to Life Coaching', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'492624c6-0271-43bf-50e7-08dbd1dd90e7', 1, N'FOUNDATION: Self Awareness as a Coach', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'55fc32d5-774e-44b3-50e8-08dbd1dd90e7', 2, N'FOUNDATION: Getting Started, Structure & Setting Expectations', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'3c4faff7-5c7c-45cf-50e9-08dbd1dd90e7', 3, N'SKILLS: Communication Techniques - Listening', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1846224d-8725-4b0c-50ea-08dbd1dd90e7', 4, N'SKILLS: Communication Techniques: Questioning', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'c2e984ee-7b22-43d4-50eb-08dbd1dd90e7', 5, N'TOOLS: Setting Goals', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
GO
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'ebe89030-a6da-478b-50ec-08dbd1dd90e7', 6, N'Coaching Tools and Techniques', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'6da88d0c-2ab0-42e6-50ed-08dbd1dd90e7', 7, N'Coaching Forms and Template', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'19a6da73-7b8c-4a46-50ee-08dbd1dd90e7', 8, N'TOOLS: Neuro Linguistic Programming (NLP) Processes', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'e6c0104e-3c3e-4ee5-50ef-08dbd1dd90e7', 9, N'MINDSET: Emotional Intelligence (EQ) as a Coach', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'fc759a84-6d14-4825-50f0-08dbd1dd90e7', 10, N'MINDSET: Growth Mindset & True Confidence', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'588cd77a-9cb6-4586-50f1-08dbd1dd90e7', 11, N'PROCESS: Developing Awareness and Mindfulness', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'93f0f9a7-01de-45e3-50f2-08dbd1dd90e7', 12, N'PROCESS: Empowering Thinking & Self-Talk', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'db147b38-d58c-4032-50f3-08dbd1dd90e7', 13, N'PROCESS: Empowering Emotions', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0f5fb20d-98e5-44f8-50f4-08dbd1dd90e7', 14, N'PROCESS: Empowering Beliefs', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'4db6828f-f11d-432e-50f5-08dbd1dd90e7', 15, N'PROCESS: Decision Making & Taking Action', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'50231d38-1d32-424f-50f6-08dbd1dd90e7', 16, N'PROCESS: Overcoming Fear of Change, Failure & Risk', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'62bef0d8-3a43-4550-50f7-08dbd1dd90e7', 17, N'PROCESS: Passion and Purpose', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'123d6784-9cc7-494a-50f8-08dbd1dd90e7', 18, N'PROCESS: Rewriting Your Life Story', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'381c1757-f0a5-4ba2-50f9-08dbd1dd90e7', 19, N'BUSINESS: Your Life Coaching Business', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'0d43d14b-58a9-46db-50fa-08dbd1dd90e7', 20, N'Wrap Up and Next Steps', 0, N'8c8d9c4d-dd56-42a2-8be6-e5fed168bdcf', CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2), CAST(N'2023-10-21T09:29:39.6800000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'87d71b99-1d4b-4f94-50fb-08dbd1dd90e7', 0, N'Introduction to Difficult People', 0, N'8be9c1d4-a830-4f33-8030-2dd6544fdc2e', CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'be5bbf54-fe71-4072-50fc-08dbd1dd90e7', 1, N'Preparing yourself', 0, N'8be9c1d4-a830-4f33-8030-2dd6544fdc2e', CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'a134ab5b-bb67-484a-50fd-08dbd1dd90e7', 2, N'Techniques and Tactics', 0, N'8be9c1d4-a830-4f33-8030-2dd6544fdc2e', CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2), CAST(N'2023-10-21T09:29:39.8200000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'f80e5cac-0ef4-4865-50fe-08dbd1dd90e7', 0, N'Success and Growth Mindset', 0, N'670896f5-b0a1-413f-9c77-07e103a131c6', CAST(N'2023-10-21T09:29:39.9000000' AS DateTime2), CAST(N'2023-10-21T09:29:39.9000000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'1f8f709e-85cd-45e4-1cde-08dbd464ab52', 0, N'java1', 0, N'00ef965c-d74e-487b-ab36-55619d89ef37', CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2), CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'7807b5f2-23b9-4d2a-1cdf-08dbd464ab52', 1, N'java2', 0, N'00ef965c-d74e-487b-ab36-55619d89ef37', CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2), CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2))
INSERT [dbo].[Sections] ([Id], [Index], [Title], [LectureCount], [CourseId], [CreationTime], [LastModificationTime]) VALUES (N'be7692ca-b3ce-4e26-1ce0-08dbd464ab52', 2, N'java3', 0, N'00ef965c-d74e-487b-ab36-55619d89ef37', CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2), CAST(N'2023-10-24T14:41:44.8300000' AS DateTime2))
GO
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'39f7f7d5-3491-4a91-bc7a-1dc3e520f834', 1.6666666666666665, 5, N'6965b04a-e57a-4cc0-ac98-c19c61eaa497', CAST(N'2023-10-24T14:46:34.8833333' AS DateTime2), CAST(N'2023-10-24T14:46:34.8833333' AS DateTime2), N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'f16260df-0e01-48b6-866a-2ab5bf04f412', 10, 8, N'bc104e6c-eec8-4dcd-b476-c34b2336bfb3', CAST(N'2023-10-20T22:47:23.1066667' AS DateTime2), CAST(N'2023-10-20T22:47:23.1066667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'b7563fa0-addb-4873-9f8e-5547ce12b07f', 10, 3, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-20T16:52:31.3000000' AS DateTime2), CAST(N'2023-10-20T16:52:31.3000000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'7ccc2cf5-d906-4e66-b58f-92edd12b3556', 10, 4, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-20T16:51:52.7800000' AS DateTime2), CAST(N'2023-10-20T16:51:52.7800000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'6223f7a1-f645-4012-8101-9b725a8ae3c5', 10, 10, N'7d55216c-dcd4-4013-8461-f1aac771417b', CAST(N'2023-10-20T22:52:45.1966667' AS DateTime2), CAST(N'2023-10-20T22:52:45.1966667' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8793defb-16fc-4c93-8d08-9d31c40ceeb2', 10, 4, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-20T16:46:23.7633333' AS DateTime2), CAST(N'2023-10-20T16:46:23.7633333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'51440a98-fd4d-477b-b9dd-a3639376ba73', 6.6666666666666661, 30, N'215adbdd-0b6d-40a5-95f1-effe85229b9e', CAST(N'2023-10-19T22:02:31.9500000' AS DateTime2), CAST(N'2023-10-19T22:02:31.9500000' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'df009258-f09e-4925-8ab4-b0220bbb3c6d', 0, 23, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-12T12:16:52.9033333' AS DateTime2), CAST(N'2023-10-12T12:16:52.9033333' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'8613f928-694e-4a8e-8b3c-bd51936609ab', 10, 13, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-17T15:35:31.8100000' AS DateTime2), CAST(N'2023-10-17T15:35:31.8100000' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'125356ba-52be-44f7-99f7-c891dea70b04', 0, 26, N'6965b04a-e57a-4cc0-ac98-c19c61eaa497', CAST(N'2023-10-24T14:45:56.1300000' AS DateTime2), CAST(N'2023-10-24T14:45:56.1300000' AS DateTime2), N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'a75133ae-48ec-4448-96d4-d1d76f6c0087', 5, 3, N'bf0bb2bb-0bfb-408c-a9f5-f263eb811288', CAST(N'2023-10-17T17:00:36.7766667' AS DateTime2), CAST(N'2023-10-17T17:00:36.7766667' AS DateTime2), N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'5b9eca74-6ee4-4851-b309-d4dd330b7bef', 10, 40, N'77d68364-fbd5-43dd-8720-926da682b0d7', CAST(N'2023-10-20T22:46:38.8433333' AS DateTime2), CAST(N'2023-10-20T22:46:38.8433333' AS DateTime2), N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'00000000-0000-0000-0000-000000000000')
INSERT [dbo].[Submissions] ([Id], [Mark], [TimeSpentInSec], [AssignmentId], [CreationTime], [LastModificationTime], [CreatorId], [LastModifierId]) VALUES (N'e4ea37aa-95a4-4391-9eb0-ee28fbfc8fd7', 10, 5, N'215adbdd-0b6d-40a5-95f1-effe85229b9e', CAST(N'2023-10-20T16:53:11.1266667' AS DateTime2), CAST(N'2023-10-20T16:53:11.1266667' AS DateTime2), N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'00000000-0000-0000-0000-000000000000')
GO
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'820ef64f-8e25-4486-86e5-027d4fddb31d', N'Fgn85761', N'4e8e2e3979c32134d566a17a8a4f8123200c5332b9f94cfb920c9a73d4eadeee', N'fgn85761@omeie.com', N'Fgn85761', N'fgn85761', N'', N'Learner', N'07fd0823-3348-4520-9e2a-a4768e3da40a', N'5c8GGA7XA/h58AXhtiDZ0bMOkpGWcYm5XdRWeRhe+shEBqFoL74eyG4i5epOXKn6V26OZqoMs/z0Y8/9M8WYQg==', 1, 0, 0, NULL, NULL, N'Fgn85761''s Bio 123456', CAST(N'2000-01-21T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-10-19T12:06:37.0547434' AS DateTime2), CAST(N'2023-10-19T15:16:38.8757743' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'8c3d6d81-2d70-4b5d-87bd-0a9b2d4da4ed', N'HuynhGiang59', N'c9d8f7bd63a68025960fc958d08973be6b458b23d68ce7bf783829a052e75a3f', N'HuynhGiang59@gmail.com', N'Huỳnh Mai Giang', N'huynh mai giang', N'Avatars/8C3D6D81-2D70-4B5D-87BD-0A9B2D4DA4ED.jpg', N'Instructor', N'', N'AAaM/HoEvI+37irfYqjxxs0FRtrhpY2adqUE3bBNWqHdPls/mkiq21hvsqsDX1v4XuF25DdEeRxjjaDcZOhDMQ==', 1, 1, 0, NULL, NULL, N'', CAST(N'1975-11-18T00:00:00.0000000' AS DateTime2), N'00450757484', 1, N'f2fbe555-5d02-441d-baeb-3a6acb740ed6', CAST(N'2023-09-23T01:54:55.6477428' AS DateTime2), CAST(N'2023-10-28T07:45:56.1225293' AS DateTime2), 2000000)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'522d2265-0532-4142-8079-0aa7e9c7d3cb', N'NguyenLoan56', N'2fe73c8e2268ff09a2b2e7f4f260b6dd678e3386fc6e93517b327d1c61e439e9', N'NguyenLoan56@gmail.com', N'Nguyễn Thu Loan', N'nguyen thu loan', N'Avatars/522D2265-0532-4142-8079-0AA7E9C7D3CB.jpg', N'Learner', N'', N'aW46MhDWAjJVkAlfKLTZUhDeKFzyXLVCdJ7KcTYXk3WgErtljeQrhTgMAiNUuu0b/pwNx0uF43aLcgC8JI5nwA==', 1, 1, 0, NULL, NULL, N'', CAST(N'2006-07-19T00:00:00.0000000' AS DateTime2), N'0880353290', 1, NULL, CAST(N'2023-09-23T01:54:55.6475926' AS DateTime2), CAST(N'2023-10-29T08:59:55.4966781' AS DateTime2), 6000000)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'55ac3b6e-48c4-4ef0-86e8-17129b0f1676', N'Snow1234', N'd4705a5b147fcc440292c184a97565e9c3f80d35139d112d320d6e6d92e738eb', N'Snow1234@gmail.com', N'Hoàng Minh Phương', N'hoang minh phuong', N'Avatars/55AC3B6E-48C4-4EF0-86E8-17129B0F1676.jpg', N'Learner', N'', N'EcBWc0wfuBmB8v9OPY6l1Gi+5x5zX+HW3ZkVgRf3KVHOF1nU+ZPV7mAqiA0p7b9vt60NO6yg5ojCjWP/m0Q5RA==', 1, 0, 0, NULL, NULL, N'', CAST(N'2014-08-10T00:00:00.0000000' AS DateTime2), N'0765432109', 0, NULL, CAST(N'2023-10-20T09:39:43.4167974' AS DateTime2), CAST(N'2023-10-24T07:42:38.4249782' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'd7067dc0-6f21-4073-9990-1c691bda358c', N'TestAdmin1', N'9a3a696c3d0b659e6698e32ca8660dbab0f916d5a190e3dca72079db88e68ab0', N'TestAdmin1@ex.com', N'Admin ABC', N'admin abc', N'Avatars/d7067dc0-6f21-4073-9990-1c691bda358c.jpg', N'Admin', N'1c9a697b-f897-4603-9695-8dc858640ea8', N'hZ2VCy90DjykVPm+p7i3D5glR4auVK6zROrsPCHXTcbyRfp0FEFFPRUKREHbnMQGSvF0IF9A2I4vF8z5iyoPbQ==', 0, 1, 0, NULL, NULL, N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-10-15T07:45:52.5172726' AS DateTime2), CAST(N'2023-10-19T15:00:10.4578055' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'603d925c-147c-4d22-82cf-23633d1c4a80', N'DangHanh16', N'b249111eca033e89f9b36c190a94b2608c987824dcb80690c4b00eee7699a7dd', N'DangHanh16@gmail.com', N'Đặng Mai Hạnh', N'dang mai hanh', N'Avatars/603D925C-147C-4D22-82CF-23633D1C4A80.jpg', N'Instructor', N'', N'DCy3OomAV2NemRFnjCCvXo9jGa91JJnp6tQ3G/k/QL/OtKjHLvXc0CuWNuuyIom6NahlwOcbY3TgUoMGRQqS3Q==', 1, 1, 0, NULL, NULL, N'', CAST(N'1992-06-20T00:00:00.0000000' AS DateTime2), N'01548917453', 1, N'ca49669e-746e-4dab-ad77-2a625d144b8b', CAST(N'2023-09-23T01:54:55.6478554' AS DateTime2), CAST(N'2023-10-24T05:54:05.5934832' AS DateTime2), 54000000)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'24acd35b-c23f-463c-95c9-27c9fef6c336', N'DinhDao22', N'd6ae77af6857cfaeae9786de9c64556dbbc26246cd06ece80e212420c3db689d', N'DinhDao22@gmail.com', N'Đinh Hoài Đào', N'dinh hoai dao', N'Avatars/24ACD35B-C23F-463C-95C9-27C9FEF6C336.jpg', N'Learner', N'', N'eK40K94bHJeEyeWg3QJXqAzQF8Un9k69YZTK8vXuXcoXO/SjwAqH5bjkLB/O4kC05T+X236LZiF25R923/ylYw==', 1, 1, 0, NULL, NULL, N'', CAST(N'1981-04-08T00:00:00.0000000' AS DateTime2), N'0974845326', 0, NULL, CAST(N'2023-09-23T01:54:55.6476159' AS DateTime2), CAST(N'2023-10-06T14:07:57.3614512' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'6d80d005-5887-4c1d-a4b6-3f6824ae1a29', N'VuThai57', N'cc1e457a2829dd9dc00e8c5b63872291c2e7c698c729244bed39b2953640bbf9', N'VuThai57@gmail.com', N'Vũ Khánh Thái', N'vu khanh thai', N'Avatars/6D80D005-5887-4C1D-A4B6-3F6824AE1A29.jpg', N'Learner', N'', N'eu2F/KEzhmrr2McQnj2J/fEMoSA5HtZCzBkwEuU5VHA01bCf3Qqmh7OFFW9bfQqSnUdAvk7lMKt+f9c/2XliCA==', 1, 1, 0, NULL, NULL, N'', CAST(N'1999-11-18T00:00:00.0000000' AS DateTime2), N'01563135375', 0, NULL, CAST(N'2023-09-23T01:54:55.6475721' AS DateTime2), CAST(N'2023-10-06T14:28:02.5139167' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'dc25bdc3-f548-4e71-90b7-449915800679', N'VoThuong56', N'82eb16f21cd082d18ad7497a1283c07e87b0ec4649799b7fab8f473b3a1f161c', N'VoThuong56@gmail.com', N'Võ Quỳnh Thương', N'vo quynh thuong', N'Avatars/DC25BDC3-F548-4E71-90B7-449915800679.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1973-09-16T00:00:00.0000000' AS DateTime2), N'0129517098', 0, NULL, CAST(N'2023-09-23T01:54:55.6476831' AS DateTime2), CAST(N'2023-09-23T01:54:55.6476831' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'19ae0139-f754-4f4a-9988-49d8f622a93c', N'VuThinh46', N'043d28bb929f5ee29f82ee0b7684f822add54bf1ca9ea1338fe85ccca25b6058', N'VuThinh46@gmail.com', N'Vũ Minh Thịnh', N'vu minh thinh', N'Avatars/19AE0139-F754-4F4A-9988-49D8F622A93C.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1985-01-15T00:00:00.0000000' AS DateTime2), N'0690109409', 0, NULL, CAST(N'2023-09-23T01:54:55.6477054' AS DateTime2), CAST(N'2023-09-23T01:54:55.6477054' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'00c6eed9-9acf-4814-b335-4bc8ff6d0401', N'NguyenBach18', N'57e29da7931688bbe2ed23c9f7030b9aeda3626ddf98dd32c9853c609f46b2aa', N'NguyenBach18@gmail.com', N'Nguyễn Công Bách', N'nguyen cong bach', N'Avatars/00C6EED9-9ACF-4814-B335-4BC8FF6D0401.jpg', N'Instructor', N'067950ef-58c1-4e5a-92c2-81014986e747', N'Dhh3MkvsvNh0PjWg68fl732eONcdtDtWPcRfV+wV2IH2wCz8noMIu16ge/bNowNOKOQoxfQlNdwl7BqDf1w9Gw==', 1, 1, 0, NULL, NULL, N'', CAST(N'2009-04-08T00:00:00.0000000' AS DateTime2), N'01685342733', 0, N'999f009d-e6ad-4b6a-91b2-964af68c65db', CAST(N'2023-09-23T01:54:55.6481778' AS DateTime2), CAST(N'2023-10-21T02:29:39.0024275' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'39dcb58a-5a86-4220-8366-518be3efe406', N'HoLoc67', N'8c70ca944f83dc74b8dcb0e33c4f389ddc7299e030ccc28b008fd37964b551c9', N'HoLoc67@gmail.com', N'Hồ Hoàng Lộc', N'ho hoang loc', N'Avatars/39DCB58A-5A86-4220-8366-518BE3EFE406.jpg', N'Instructor', N'', N'f5w9pdL7DKS4/W0ZjQu27tdOshSZrr8PagHWWYooL/cnv6xAGoszshMqBYJNSixFqtkwMmZhp5LF7K9YkJfGrQ==', 1, 1, 0, NULL, NULL, N'', CAST(N'1985-06-19T00:00:00.0000000' AS DateTime2), N'00401525859', 0, N'06752c05-4374-4449-b8a9-2c3dc2a0d0fc', CAST(N'2023-09-23T01:54:55.6482239' AS DateTime2), CAST(N'2023-10-23T02:48:26.4061032' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'1e512cf4-856b-4dd8-94b1-521c71276d8a', N'TigerLion9', N'a42428bffdea0e6ad61eaaefb6679713e6ce56021d6a81199cdf260714d0b781', N'TigerLion9@gmail.com', N'Lê Văn Đức', N'le van duc', N'Avatars/1E512CF4-856B-4DD8-94B1-521C71276D8A.jpg', N'Admin', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'2005-02-10T00:00:00.0000000' AS DateTime2), N'0123456789', 0, NULL, CAST(N'2023-10-20T09:39:43.4167755' AS DateTime2), CAST(N'2023-10-20T09:39:43.4167755' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'1a372bae-b8e0-40e7-b0f1-616312348a53', N'DoPhong75', N'd0e90bf24c4c0be8f6f267c2194bc994fa50e9c1238980fe87b9407b2fa767ae', N'DoPhong75@gmail.com', N'Đỗ Đăng Phong', N'do dang phong', N'Avatars/1A372BAE-B8E0-40E7-B0F1-616312348A53.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1994-11-14T00:00:00.0000000' AS DateTime2), N'0760944679', 0, NULL, CAST(N'2023-09-23T01:54:55.6479121' AS DateTime2), CAST(N'2023-09-23T01:54:55.6479121' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'28cc5c62-66ce-409a-a690-6289c9f9e28f', N'TestAdmin3', N'39eb5c76541b8a1dade6c882dc2af2639ab142bb83df033b955b8aff97bd3a6a', N'TestAdmin3@example.com', N'TestAdmin3', N'testadmin3', N'', N'Admin', N'2a43c9cb-07e9-4746-a205-1ac542b66395', N'', 0, 1, 0, NULL, NULL, N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-10-19T16:31:41.2506137' AS DateTime2), CAST(N'2023-10-19T16:31:41.2506137' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'e6d6fab7-2cb9-4497-a132-669da88dc433', N'HoChi30', N'befe0cdcfc65a3906fee565266e4101908f215cadd9d9b1a3e6ee5b68eec5b95', N'HoChi30@gmail.com', N'Hồ Quỳnh Chi', N'ho quynh chi', N'Avatars/E6D6FAB7-2CB9-4497-A132-669DA88DC433.jpg', N'Learner', N'', N'', 1, 0, 100, NULL, NULL, N'', CAST(N'2009-06-12T00:00:00.0000000' AS DateTime2), N'06097509266', 0, NULL, CAST(N'2023-09-23T01:54:55.6476619' AS DateTime2), CAST(N'2023-09-23T01:54:55.6476619' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'55fff9c2-1b12-43db-8cf5-6d19837b19e0', N'LyViet19', N'ff20b924feb47e424ad59e88dfd36a8b2aa7dfb31d4d2259ef4931c19d66b1e5', N'LyViet19@gmail.com', N'Lý Văn Việt', N'ly van viet', N'Avatars/55FFF9C2-1B12-43DB-8CF5-6D19837B19E0.jpg', N'Learner', N'', N'Cr4vHT+l4pf2ZMCeegbqVNA8mSeg+4dlv3nMc18EM9xFe/pSl85YedN59+WFFUjxUvT+N9Re2tXUP0gGODrYPA==', 1, 0, 6, NULL, NULL, N'', CAST(N'1971-05-15T00:00:00.0000000' AS DateTime2), N'07294636917', 0, NULL, CAST(N'2023-09-23T01:54:55.6477988' AS DateTime2), CAST(N'2023-10-14T15:47:30.9623854' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'f20592b8-89f9-4b8a-9823-7154da6060e0', N'LyLoan24', N'3e81bee90049eefdc05848b0c41b925a6f639aad8b90dba7340c40ae0c669440', N'LyLoan24@gmail.com', N'Lý Mai Loan', N'ly mai loan', N'Avatars/F20592B8-89F9-4B8A-9823-7154DA6060E0.jpg', N'Learner', N'', N'', 1, 0, 0, NULL, NULL, N'', CAST(N'1987-02-26T00:00:00.0000000' AS DateTime2), N'0032945277', 0, NULL, CAST(N'2023-09-23T01:54:55.6477811' AS DateTime2), CAST(N'2023-09-23T01:54:55.6477811' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'76a9760f-71ad-4961-b495-71754f600a16', N'Username12345', N'f352c14c3ad8e4963ae2f2ee030fcb8074c14663c9229fe50c01706c5f91c8bd', N'fnbdfb@gmail.c', N'Username12345', N'username12345', N'Avatars/76A9760F-71AD-4961-B495-71754F600A16.jpg', N'Learner', N'319cc146-e104-40e7-9e6c-046958633a53', N'', 0, 0, 0, NULL, NULL, N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-09-26T06:41:10.2549286' AS DateTime2), CAST(N'2023-09-26T06:41:10.2549286' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'5a173682-d174-4e07-8a60-79fcbc5be567', N'HuynhGiang60', N'aa403a90756ba51fb460d6428b2e251881cf7387f0b832433d4b53ed7a9250db', N'kkj41929@zslsz.com', N'HuynhGiang60', N'huynhgiang60', N'', N'Learner', N'8efc7e85-f02e-47f9-a54f-b5e2fa7d73e1', N'DIzqyywcivcsuwHbNmcsjYjjorT8zqlOsh3VcerwkMck/WljPuFKrk1gtDF7SfFmtWfYMEsyv5TWL8LDKTfLhg==', 1, 0, 0, NULL, NULL, N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-10-29T12:17:06.7099690' AS DateTime2), CAST(N'2023-10-29T12:17:26.5646296' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'6f7f58d4-acbb-434f-a7d2-7be87933f2d7', N'PhamBich17', N'146b3bd3c575f937d559b1fb0cc80e65388b4a16569d344ce8d19f53e18d0130', N'PhamBich17@gmail.com', N'Phạm Hoài Bích', N'pham hoai bich', N'Avatars/6F7F58D4-ACBB-434F-A7D2-7BE87933F2D7.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1991-06-24T00:00:00.0000000' AS DateTime2), N'0085966445', 0, NULL, CAST(N'2023-09-23T01:54:55.6476415' AS DateTime2), CAST(N'2023-09-23T01:54:55.6476415' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'e5bab3bd-0631-4ff0-9d34-80253699c038', N'LyBich56', N'50ff471dac2f347c9678cdb0dd4cdeb4b8139f3e5cd2d94bcaf7a7bc0286a371', N'LyBich56@gmail.com', N'Lý Quỳnh Bích', N'ly quynh bich', N'Avatars/E5BAB3BD-0631-4FF0-9D34-80253699C038.jpg', N'Learner', N'', N'bbRXiJyXz+bLexZ5kGjE+np4dnw7AufcxCOiRJjsD0ADXtcDRpglElrJzdNa3keAg+3wfgE7S4G/DOqpBBAu3A==', 1, 1, 0, NULL, NULL, N'', CAST(N'1987-08-13T00:00:00.0000000' AS DateTime2), N'04916900996', 0, NULL, CAST(N'2023-09-23T01:54:55.6478936' AS DateTime2), CAST(N'2023-10-02T09:40:38.2292465' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'9f32b3ba-e7c5-4f58-81b8-8096f6f99c79', N'TruongYen82', N'99a7a8b9816e2ca979967beba76007778e074bc0787a09df58d5f34736a4e715', N'TruongYen82@gmail.com', N'Trương Mai Yến', N'truong mai yen', N'Avatars/9F32B3BA-E7C5-4F58-81B8-8096F6F99C79.jpg', N'Learner', N'', N'BFBlw7MzygRZ0XVOgL4G3qXJNrKp38FL7O1AN30lUkEe7G2PXjMhRDqVDlnf5q7sP+lwilG6umNf2LaTAIJ0Jg==', 1, 1, 0, NULL, NULL, N'', CAST(N'2008-02-21T00:00:00.0000000' AS DateTime2), N'02233673108', 1, NULL, CAST(N'2023-09-23T01:54:55.6322174' AS DateTime2), CAST(N'2023-10-23T08:21:24.6106242' AS DateTime2), 6000000)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'0e322eb7-422d-4fc6-bfc4-8797538bec3c', N'SkyDiver7', N'1ed55dfef2eced4656c99105aa95c43f2cfc26c67e84c54425a30b502dbdcb74', N'SkyDiver7@gmail.com', N'Trần Thu Hương', N'tran thu huong', N'Avatars/0E322EB7-422D-4FC6-BFC4-8797538BEC3C.jpg', N'SysAdmin', N'', N'0RW0ZSMJVVQAGxKON7QVckeDakehka58yPj8+Z2lIk02Pggkj3uhHU91DMnzTVDTFxe/42fZHp83dWxHXewc/w==', 1, 1, 0, NULL, NULL, N'Một giáo viên dạy ngoại ngữ với hơn 20 năm kinh nghiệm giảng dạy.', CAST(N'2002-12-30T00:00:00.0000000' AS DateTime2), N'0311202002', 0, NULL, CAST(N'2023-10-20T09:39:43.4167558' AS DateTime2), CAST(N'2023-10-27T16:54:53.0611671' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'ac9d2a6c-8e7f-4d1e-96e3-8995c192b262', N'MoonStar8', N'ae18219577198df47a82b9c66eb0663e458bbed0949b88a16f33d1be6025d555', N'MoonStar8@gmail.com', N'Phạm Thanh Mai', N'pham thanh mai', N'Avatars/AC9D2A6C-8E7F-4D1E-96E3-8995C192B262.jpg', N'Instructor', N'', N'vHKYYAgBoKIA1ndqMwUNGyat5LIsq2JnODiihqMXu9UN+eOzZHc1bCQ7Mni6pSAGC/P8oGdtfLW11k0QP3yL0g==', 1, 1, 0, NULL, NULL, N'', CAST(N'1998-07-05T00:00:00.0000000' AS DateTime2), N'0987654321', 0, NULL, CAST(N'2023-10-20T09:39:43.4167862' AS DateTime2), CAST(N'2023-10-21T02:29:39.5865087' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'bda2a548-450a-402e-a75a-9712bcc6fc31', N'BuiLan19', N'0e60dac782e8b97db5602b65a10a599c0930e7dee3efc908775572b07c174e95', N'BuiLan19@gmail.com', N'Bùi Mai Lan', N'bui mai lan', N'Avatars/BDA2A548-450A-402E-A75A-9712BCC6FC31.jpg', N'Learner', N'', N'XkelHTm9hvoslq3VdA8eg9wlZmHV5zhkj+wLZsmLtTvPkvniVCoE+MaAcqLu9km6+5DAdRs/Fxi8RKEIgOhb2g==', 1, 1, 0, NULL, NULL, N'', CAST(N'1973-10-14T00:00:00.0000000' AS DateTime2), N'02644001876', 1, NULL, CAST(N'2023-09-23T01:54:55.6475442' AS DateTime2), CAST(N'2023-10-24T05:51:55.8310476' AS DateTime2), 62000000)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'548bc0c0-d691-497f-a3e4-99e1fe5e25ed', N'BuiHieu74', N'09c4e6e61e4aaf642ced22d4b6ac75baa39c3813da5d98e52194364c27d15b82', N'BuiHieu74@gmail.com', N'Bùi Công Hiếu', N'bui cong hieu', N'Avatars/548BC0C0-D691-497F-A3E4-99E1FE5E25ED.jpg', N'Learner', N'', N'EMxkY/Mtuz5c7HEkEF5RTLzsrEXTSso5wPuHJc+fZNh6argTvupPaSjfT86/eyhJMPBVh6h8oKac1+IC5snoUg==', 1, 1, 0, NULL, NULL, N'', CAST(N'1977-07-19T00:00:00.0000000' AS DateTime2), N'00297247839', 0, NULL, CAST(N'2023-09-23T01:54:55.6477249' AS DateTime2), CAST(N'2023-10-06T13:54:01.3424996' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'7a7bb1cd-25f9-4d44-8f8e-9a8d10d2eb98', N'FireIce6', N'22c8830d4bdb17f4276bf6cd7730a9fd5ea76db2549957ab302fc2600caab433', N'FireIce6@gmail.com', N'Vũ Thị Thuỳ Linh', N'vu thi thuy linh', N'Avatars/7A7BB1CD-25F9-4D44-8F8E-9A8D10D2EB98.jpg', N'Learner', N'', N'', 0, 0, 0, NULL, NULL, N'', CAST(N'2013-05-03T00:00:00.0000000' AS DateTime2), N'0345678901', 0, NULL, CAST(N'2023-10-20T09:39:43.4168066' AS DateTime2), CAST(N'2023-10-20T09:39:43.4168066' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'1e4951f8-74a9-4459-8e59-9dd2748dea0e', N'VuThong64', N'7ebf4c3f8af917eec8f8f6cba0e52c67a1408b22e64f07a4a7dc629fd1b3612a', N'VuThong64@gmail.com', N'Vũ Đăng Thông', N'vu dang thong', N'Avatars/1E4951F8-74A9-4459-8E59-9DD2748DEA0E.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1989-01-05T00:00:00.0000000' AS DateTime2), N'0727236907', 0, NULL, CAST(N'2023-09-23T01:54:55.6477616' AS DateTime2), CAST(N'2023-09-23T01:54:55.6477616' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'6968cf0a-52ac-44db-8a8e-9ebb59545a66', N'TruongNhan64', N'9bfa964ba69a48ee16cafe1d74923bee17f77c51abbf9e054e1e0b95de8186d5', N'TruongNhan64@gmail.com', N'Trương Huy Nhân', N'truong huy nhan', N'Avatars/6968CF0A-52AC-44DB-8A8E-9EBB59545A66.jpg', N'Instructor', N'', N'OEW3k5Ew4bNulK9TDc76fgEPuemqR5W2msf7gmI75X7oX7ylOyyiXRV9whYfMaPSkgmJ9ev52LQjFvpSNepjTQ==', 1, 1, 0, NULL, NULL, N'', CAST(N'2004-02-16T00:00:00.0000000' AS DateTime2), N'0498370064', 0, N'24e17038-36db-4bc0-bf12-e26af1cdbd6d', CAST(N'2023-09-23T01:54:55.6482437' AS DateTime2), CAST(N'2023-10-23T07:37:17.3017916' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'383a4400-c1d4-495d-8893-b1b223aa86f9', N'TruongHuy19', N'13552f5926f5b9d8eb3b7d72f8b2603aa1fd307e47265184025302bd0da74a64', N'TruongHuy19@gmail.com', N'Trương Đức Huy', N'truong duc huy', N'Avatars/383A4400-C1D4-495D-8893-B1B223AA86F9.jpg', N'Learner', N'', N'', 1, 1, 0, NULL, NULL, N'', CAST(N'1987-11-14T00:00:00.0000000' AS DateTime2), N'0860024636', 0, NULL, CAST(N'2023-09-23T01:54:55.6478180' AS DateTime2), CAST(N'2023-09-23T01:54:55.6478180' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'b8db9868-81b1-4fd9-80aa-bb1fb45ce337', N'An Than Trong', N'91220bd2b34f75f3842304379c5416d5b9eec7244804f73e4af2486eaf2c8637', N'antrongdn2021@gmail.com', N'An Than Trong', N'an than trong', N'Avatars/B8DB9868-81B1-4FD9-80AA-BB1FB45CE337.jpg', N'Learner', N'71096229-dee5-41dd-9aa7-986de54cb860', N'', 1, 0, 0, N'Google', N'109937840177129453568', N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-10-06T07:10:43.1281081' AS DateTime2), CAST(N'2023-10-06T07:10:43.1281093' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'4d123a44-a745-4ff9-a817-be09c419296b', N'qgs41198', N'6401080d672f5faf496e80c862af760c2ff7761c7f4b64c7a9f999e1732f51fc', N'qgs41198@zbock.com', N'Tên User 123', N'ten user 123', N'Avatars/4D123A44-A745-4FF9-A817-BE09C419296B.jpg', N'Learner', N'0a274295-4703-42ab-99cb-0f004dd299d0', N'G74BW9SAoGe5H2042x3Wx2dfvzBcVMLKMDyfO19yj3Jk6PH2irIhhyomYZgSyXGaX8bB8RiX8+VypWhrPyF4LA==', 1, 0, 0, NULL, NULL, N'', CAST(N'2000-01-01T00:00:00.0000000' AS DateTime2), NULL, 0, NULL, CAST(N'2023-09-27T04:01:48.1295574' AS DateTime2), CAST(N'2023-09-27T04:04:20.5274523' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'221c8992-0471-4524-b631-ca4bc6369315', N'BuiKhoa6', N'1cf2d93faaac65a8048947650d5bcbd5c8ee82a39ee139fa9249fddd8d4c5bb5', N'BuiKhoa6@gmail.com', N'Bùi Mạnh Khoa', N'bui manh khoa', N'Avatars/221C8992-0471-4524-B631-CA4BC6369315.jpg', N'Instructor', N'', N'94UtbAa2QfelxnY7ab8nRjJlCo+atCA0VBLjQ09QnXibjEszARNIYec8BBB+Jg6/WsDBbvmSDM6cg01+gS2lkQ==', 1, 1, 0, NULL, NULL, N'', CAST(N'1988-01-17T00:00:00.0000000' AS DateTime2), N'06436964330', 0, N'466b1386-9ca9-4a88-a5d7-736954a0c1a3', CAST(N'2023-09-23T01:54:55.6482042' AS DateTime2), CAST(N'2023-10-21T02:29:39.2468343' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'4de27447-32c1-4f2f-94e2-e3ca2f3b82a8', N'HoangMy56', N'3bcc8917f2abf15c49578132ed90eced8e0f1277cd726054f74ad914fb7d0690', N'HoangMy56@gmail.com', N'Hoàng Hoài My', N'hoang hoai my', N'Avatars/4DE27447-32C1-4F2F-94E2-E3CA2F3B82A8.jpg', N'Learner', N'', N'3PPNYWIaGswpYbw6aVVraQ8mgY8ifXZ+uvD22DutFBd5cL/qMHst/PYfn+GVwVBcvGcKT+QrHY2jTuq51bDCFw==', 1, 1, 0, NULL, NULL, N'', CAST(N'2007-04-27T00:00:00.0000000' AS DateTime2), N'0904280485', 0, NULL, CAST(N'2023-09-23T01:54:55.6478357' AS DateTime2), CAST(N'2023-10-23T08:55:38.3151710' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'8ffa47df-6d05-473b-b017-e69625fb1e82', N'LeHuy29', N'efc172c28116ad70fffb291b6826693b81fc5b695145e5a44fb26aeb1a42b6b5', N'LeHuy29@gmail.com', N'Lê Khánh Huy', N'le khanh huy', N'Avatars/8FFA47DF-6D05-473B-B017-E69625FB1E82.jpg', N'Learner', N'', N'', 1, 0, 100, NULL, NULL, N'', CAST(N'1994-02-05T00:00:00.0000000' AS DateTime2), N'0985171883', 0, NULL, CAST(N'2023-09-23T01:54:55.6478735' AS DateTime2), CAST(N'2023-09-23T01:54:55.6478735' AS DateTime2), 0)
INSERT [dbo].[Users] ([Id], [UserName], [Password], [Email], [FullName], [MetaFullName], [AvatarUrl], [Role], [Token], [RefreshToken], [IsVerified], [IsApproved], [AccessFailedCount], [LoginProvider], [ProviderKey], [Bio], [DateOfBirth], [Phone], [EnrollmentCount], [InstructorId], [CreationTime], [LastModificationTime], [SystemBalance]) VALUES (N'ac69fdb5-adce-4e81-8453-f7cbb759d2f0', N'NgoQuynh78', N'd375b41c84f98fcbef6ccb75783de38a037d04a7f69d037211b56278cd6adafc', N'NgoQuynh78@gmail.com', N'Ngô Hoài Quỳnh', N'ngo hoai quynh', N'Avatars/AC69FDB5-ADCE-4E81-8453-F7CBB759D2F0.jpg', N'Instructor', N'', N'15WzYQh09bnwfcTleYBM0V7dfx25mD2gVCfVsPPrveHw6IbR/Fh+cRFJ01N5TLwuNpasDwdFGOOCobPRcWCi7A==', 1, 1, 0, NULL, NULL, N'', CAST(N'1976-02-11T00:00:00.0000000' AS DateTime2), N'0442333215', 0, N'337c40b6-457c-4b7a-81f5-af9934ce46b5', CAST(N'2023-09-23T01:54:55.6479309' AS DateTime2), CAST(N'2023-10-30T13:02:51.3664855' AS DateTime2), 0)
GO
/****** Object:  Index [IX_Articles_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Articles_CreatorId] ON [dbo].[Articles]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Articles_Title]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Articles_Title] ON [dbo].[Articles]
(
	[Title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Assignments_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Assignments_CreatorId] ON [dbo].[Assignments]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Assignments_SectionId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Assignments_SectionId] ON [dbo].[Assignments]
(
	[SectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Bills_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Bills_CreatorId] ON [dbo].[Bills]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Categories_Description]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Categories_Description] ON [dbo].[Categories]
(
	[Description] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Categories_Path]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Categories_Path] ON [dbo].[Categories]
(
	[Path] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Categories_Title]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Categories_Title] ON [dbo].[Categories]
(
	[Title] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ChatMessages_ConversationId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ChatMessages_ConversationId] ON [dbo].[ChatMessages]
(
	[ConversationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ChatMessages_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ChatMessages_CreatorId] ON [dbo].[ChatMessages]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Comments_ArticleId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_ArticleId] ON [dbo].[Comments]
(
	[ArticleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Comments_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CreatorId] ON [dbo].[Comments]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Comments_LectureId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_LectureId] ON [dbo].[Comments]
(
	[LectureId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Comments_ParentId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_ParentId] ON [dbo].[Comments]
(
	[ParentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_ConversationMembers_ConversationId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_ConversationMembers_ConversationId] ON [dbo].[ConversationMembers]
(
	[ConversationId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Conversations_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Conversations_CreatorId] ON [dbo].[Conversations]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CourseReviews_CourseId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_CourseReviews_CourseId] ON [dbo].[CourseReviews]
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_CourseReviews_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_CourseReviews_CreatorId] ON [dbo].[CourseReviews]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Courses_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Courses_CreatorId] ON [dbo].[Courses]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Courses_InstructorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Courses_InstructorId] ON [dbo].[Courses]
(
	[InstructorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Courses_LeafCategoryId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Courses_LeafCategoryId] ON [dbo].[Courses]
(
	[LeafCategoryId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Enrollments_BillId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Enrollments_BillId] ON [dbo].[Enrollments]
(
	[BillId] ASC
)
WHERE ([BillId] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Enrollments_CourseId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Enrollments_CourseId] ON [dbo].[Enrollments]
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Instructors_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Instructors_CreatorId] ON [dbo].[Instructors]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Lectures_SectionId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Lectures_SectionId] ON [dbo].[Lectures]
(
	[SectionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_McqChoices_McqQuestionId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_McqChoices_McqQuestionId] ON [dbo].[McqChoices]
(
	[McqQuestionId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_McqQuestions_AssignmentId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_McqQuestions_AssignmentId] ON [dbo].[McqQuestions]
(
	[AssignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_McqUserAnswer_MCQChoiceId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_McqUserAnswer_MCQChoiceId] ON [dbo].[McqUserAnswer]
(
	[MCQChoiceId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_CreatorId] ON [dbo].[Notifications]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Notifications_ReceiverId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Notifications_ReceiverId] ON [dbo].[Notifications]
(
	[ReceiverId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reactions_ArticleId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reactions_ArticleId] ON [dbo].[Reactions]
(
	[ArticleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reactions_ChatMessageId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reactions_ChatMessageId] ON [dbo].[Reactions]
(
	[ChatMessageId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Reactions_CommentId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Reactions_CommentId] ON [dbo].[Reactions]
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Sections_CourseId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Sections_CourseId] ON [dbo].[Sections]
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Submissions_AssignmentId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Submissions_AssignmentId] ON [dbo].[Submissions]
(
	[AssignmentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
/****** Object:  Index [IX_Submissions_CreatorId]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE NONCLUSTERED INDEX [IX_Submissions_CreatorId] ON [dbo].[Submissions]
(
	[CreatorId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Email]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Email] ON [dbo].[Users]
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_Phone]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_Phone] ON [dbo].[Users]
(
	[Phone] ASC
)
WHERE ([Phone] IS NOT NULL)
WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
SET ANSI_PADDING ON
GO
/****** Object:  Index [IX_Users_UserName]    Script Date: 10/31/2023 1:26:54 PM ******/
CREATE UNIQUE NONCLUSTERED INDEX [IX_Users_UserName] ON [dbo].[Users]
(
	[UserName] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Articles] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Articles] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Assignments] ADD  DEFAULT ('00000000-0000-0000-0000-000000000000') FOR [CreatorId]
GO
ALTER TABLE [dbo].[Assignments] ADD  DEFAULT ((0.0000000000000000e+000)) FOR [GradeToPass]
GO
ALTER TABLE [dbo].[Bills] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Categories] ADD  DEFAULT ((0)) FOR [CourseCount]
GO
ALTER TABLE [dbo].[ChatMessages] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[ChatMessages] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Comments] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[ConversationMembers] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Conversations] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[CourseReviews] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[CourseReviews] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Courses] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Courses] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT (N'') FOR [AssignmentMilestones]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT (N'') FOR [LectureMilestones]
GO
ALTER TABLE [dbo].[Enrollments] ADD  DEFAULT (N'') FOR [SectionMilestones]
GO
ALTER TABLE [dbo].[Instructors] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Instructors] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Instructors] ADD  DEFAULT (CONVERT([tinyint],(0))) FOR [CourseCount]
GO
ALTER TABLE [dbo].[Lectures] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Lectures] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Lectures] ADD  DEFAULT (CONVERT([bit],(0))) FOR [IsPreviewable]
GO
ALTER TABLE [dbo].[Notifications] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Sections] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Sections] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Submissions] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Submissions] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [CreationTime]
GO
ALTER TABLE [dbo].[Users] ADD  DEFAULT (getdate()) FOR [LastModificationTime]
GO
ALTER TABLE [dbo].[Articles]  WITH CHECK ADD  CONSTRAINT [FK_Articles_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Articles] CHECK CONSTRAINT [FK_Articles_Users_CreatorId]
GO
ALTER TABLE [dbo].[Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Assignments_Sections_SectionId] FOREIGN KEY([SectionId])
REFERENCES [dbo].[Sections] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Assignments] CHECK CONSTRAINT [FK_Assignments_Sections_SectionId]
GO
ALTER TABLE [dbo].[Assignments]  WITH CHECK ADD  CONSTRAINT [FK_Assignments_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Assignments] CHECK CONSTRAINT [FK_Assignments_Users_CreatorId]
GO
ALTER TABLE [dbo].[Bills]  WITH CHECK ADD  CONSTRAINT [FK_Bills_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Bills] CHECK CONSTRAINT [FK_Bills_Users_CreatorId]
GO
ALTER TABLE [dbo].[ChatMessages]  WITH CHECK ADD  CONSTRAINT [FK_ChatMessages_Conversations_ConversationId] FOREIGN KEY([ConversationId])
REFERENCES [dbo].[Conversations] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ChatMessages] CHECK CONSTRAINT [FK_ChatMessages_Conversations_ConversationId]
GO
ALTER TABLE [dbo].[ChatMessages]  WITH CHECK ADD  CONSTRAINT [FK_ChatMessages_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[ChatMessages] CHECK CONSTRAINT [FK_ChatMessages_Users_CreatorId]
GO
ALTER TABLE [dbo].[CommentMedia]  WITH CHECK ADD  CONSTRAINT [FK_CommentMedia_Comments_CommentId] FOREIGN KEY([CommentId])
REFERENCES [dbo].[Comments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CommentMedia] CHECK CONSTRAINT [FK_CommentMedia_Comments_CommentId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Articles_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Articles] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Articles_ArticleId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Comments_ParentId] FOREIGN KEY([ParentId])
REFERENCES [dbo].[Comments] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Comments_ParentId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Lectures_LectureId] FOREIGN KEY([LectureId])
REFERENCES [dbo].[Lectures] ([Id])
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Lectures_LectureId]
GO
ALTER TABLE [dbo].[Comments]  WITH CHECK ADD  CONSTRAINT [FK_Comments_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Comments] CHECK CONSTRAINT [FK_Comments_Users_CreatorId]
GO
ALTER TABLE [dbo].[ConversationMembers]  WITH CHECK ADD  CONSTRAINT [FK_ConversationMembers_Conversations_ConversationId] FOREIGN KEY([ConversationId])
REFERENCES [dbo].[Conversations] ([Id])
GO
ALTER TABLE [dbo].[ConversationMembers] CHECK CONSTRAINT [FK_ConversationMembers_Conversations_ConversationId]
GO
ALTER TABLE [dbo].[ConversationMembers]  WITH CHECK ADD  CONSTRAINT [FK_ConversationMembers_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[ConversationMembers] CHECK CONSTRAINT [FK_ConversationMembers_Users_CreatorId]
GO
ALTER TABLE [dbo].[Conversations]  WITH CHECK ADD  CONSTRAINT [FK_Conversations_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Conversations] CHECK CONSTRAINT [FK_Conversations_Users_CreatorId]
GO
ALTER TABLE [dbo].[CourseMeta]  WITH CHECK ADD  CONSTRAINT [FK_CourseMeta_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseMeta] CHECK CONSTRAINT [FK_CourseMeta_Courses_CourseId]
GO
ALTER TABLE [dbo].[CourseReviews]  WITH CHECK ADD  CONSTRAINT [FK_CourseReviews_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseReviews] CHECK CONSTRAINT [FK_CourseReviews_Courses_CourseId]
GO
ALTER TABLE [dbo].[CourseReviews]  WITH CHECK ADD  CONSTRAINT [FK_CourseReviews_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[CourseReviews] CHECK CONSTRAINT [FK_CourseReviews_Users_CreatorId]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_Categories_LeafCategoryId] FOREIGN KEY([LeafCategoryId])
REFERENCES [dbo].[Categories] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_Categories_LeafCategoryId]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_Instructors_InstructorId] FOREIGN KEY([InstructorId])
REFERENCES [dbo].[Instructors] ([Id])
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_Instructors_InstructorId]
GO
ALTER TABLE [dbo].[Courses]  WITH CHECK ADD  CONSTRAINT [FK_Courses_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Courses] CHECK CONSTRAINT [FK_Courses_Users_CreatorId]
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD  CONSTRAINT [FK_Enrollments_Bills_BillId] FOREIGN KEY([BillId])
REFERENCES [dbo].[Bills] ([Id])
GO
ALTER TABLE [dbo].[Enrollments] CHECK CONSTRAINT [FK_Enrollments_Bills_BillId]
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD  CONSTRAINT [FK_Enrollments_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Enrollments] CHECK CONSTRAINT [FK_Enrollments_Courses_CourseId]
GO
ALTER TABLE [dbo].[Enrollments]  WITH CHECK ADD  CONSTRAINT [FK_Enrollments_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Enrollments] CHECK CONSTRAINT [FK_Enrollments_Users_CreatorId]
GO
ALTER TABLE [dbo].[Instructors]  WITH CHECK ADD  CONSTRAINT [FK_Instructors_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Instructors] CHECK CONSTRAINT [FK_Instructors_Users_CreatorId]
GO
ALTER TABLE [dbo].[LectureMaterial]  WITH CHECK ADD  CONSTRAINT [FK_LectureMaterial_Lectures_LectureId] FOREIGN KEY([LectureId])
REFERENCES [dbo].[Lectures] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[LectureMaterial] CHECK CONSTRAINT [FK_LectureMaterial_Lectures_LectureId]
GO
ALTER TABLE [dbo].[Lectures]  WITH CHECK ADD  CONSTRAINT [FK_Lectures_Sections_SectionId] FOREIGN KEY([SectionId])
REFERENCES [dbo].[Sections] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Lectures] CHECK CONSTRAINT [FK_Lectures_Sections_SectionId]
GO
ALTER TABLE [dbo].[McqChoices]  WITH CHECK ADD  CONSTRAINT [FK_McqChoices_McqQuestions_McqQuestionId] FOREIGN KEY([McqQuestionId])
REFERENCES [dbo].[McqQuestions] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[McqChoices] CHECK CONSTRAINT [FK_McqChoices_McqQuestions_McqQuestionId]
GO
ALTER TABLE [dbo].[McqQuestions]  WITH CHECK ADD  CONSTRAINT [FK_McqQuestions_Assignments_AssignmentId] FOREIGN KEY([AssignmentId])
REFERENCES [dbo].[Assignments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[McqQuestions] CHECK CONSTRAINT [FK_McqQuestions_Assignments_AssignmentId]
GO
ALTER TABLE [dbo].[McqUserAnswer]  WITH CHECK ADD  CONSTRAINT [FK_McqUserAnswer_McqChoices_MCQChoiceId] FOREIGN KEY([MCQChoiceId])
REFERENCES [dbo].[McqChoices] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[McqUserAnswer] CHECK CONSTRAINT [FK_McqUserAnswer_McqChoices_MCQChoiceId]
GO
ALTER TABLE [dbo].[McqUserAnswer]  WITH CHECK ADD  CONSTRAINT [FK_McqUserAnswer_Submissions_SubmissionId] FOREIGN KEY([SubmissionId])
REFERENCES [dbo].[Submissions] ([Id])
GO
ALTER TABLE [dbo].[McqUserAnswer] CHECK CONSTRAINT [FK_McqUserAnswer_Submissions_SubmissionId]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users_CreatorId]
GO
ALTER TABLE [dbo].[Notifications]  WITH CHECK ADD  CONSTRAINT [FK_Notifications_Users_ReceiverId] FOREIGN KEY([ReceiverId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Notifications] CHECK CONSTRAINT [FK_Notifications_Users_ReceiverId]
GO
ALTER TABLE [dbo].[Reactions]  WITH CHECK ADD  CONSTRAINT [FK_Reactions_Articles_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Articles] ([Id])
GO
ALTER TABLE [dbo].[Reactions] CHECK CONSTRAINT [FK_Reactions_Articles_ArticleId]
GO
ALTER TABLE [dbo].[Reactions]  WITH CHECK ADD  CONSTRAINT [FK_Reactions_ChatMessages_ChatMessageId] FOREIGN KEY([ChatMessageId])
REFERENCES [dbo].[ChatMessages] ([Id])
GO
ALTER TABLE [dbo].[Reactions] CHECK CONSTRAINT [FK_Reactions_ChatMessages_ChatMessageId]
GO
ALTER TABLE [dbo].[Reactions]  WITH CHECK ADD  CONSTRAINT [FK_Reactions_Comments_CommentId] FOREIGN KEY([CommentId])
REFERENCES [dbo].[Comments] ([Id])
GO
ALTER TABLE [dbo].[Reactions] CHECK CONSTRAINT [FK_Reactions_Comments_CommentId]
GO
ALTER TABLE [dbo].[Sections]  WITH CHECK ADD  CONSTRAINT [FK_Sections_Courses_CourseId] FOREIGN KEY([CourseId])
REFERENCES [dbo].[Courses] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Sections] CHECK CONSTRAINT [FK_Sections_Courses_CourseId]
GO
ALTER TABLE [dbo].[Submissions]  WITH CHECK ADD  CONSTRAINT [FK_Submissions_Assignments_AssignmentId] FOREIGN KEY([AssignmentId])
REFERENCES [dbo].[Assignments] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Submissions] CHECK CONSTRAINT [FK_Submissions_Assignments_AssignmentId]
GO
ALTER TABLE [dbo].[Submissions]  WITH CHECK ADD  CONSTRAINT [FK_Submissions_Users_CreatorId] FOREIGN KEY([CreatorId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Submissions] CHECK CONSTRAINT [FK_Submissions_Users_CreatorId]
GO
ALTER TABLE [dbo].[Tag]  WITH CHECK ADD  CONSTRAINT [FK_Tag_Articles_ArticleId] FOREIGN KEY([ArticleId])
REFERENCES [dbo].[Articles] ([Id])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Tag] CHECK CONSTRAINT [FK_Tag_Articles_ArticleId]
GO
/****** Object:  Trigger [dbo].[onCourseReviewInsertDelete]    Script Date: 10/31/2023 1:26:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[onCourseReviewInsertDelete] ON [dbo].[CourseReviews] FOR INSERT, DELETE
AS
	BEGIN
		DECLARE @rating INT;
		IF EXISTS (SELECT * FROM inserted)
			BEGIN
				SELECT @rating = Rating FROM inserted;

				UPDATE Courses
					SET RatingCount += 1, TotalRating += @rating
					WHERE Id = (SELECT CourseId FROM inserted);
			END
		ELSE
			BEGIN
				SELECT @rating = Rating FROM deleted;

				UPDATE Courses
					SET RatingCount -= 1, TotalRating -= @rating
					WHERE Id = (SELECT CourseId FROM deleted);
			END
	END
GO
ALTER TABLE [dbo].[CourseReviews] ENABLE TRIGGER [onCourseReviewInsertDelete]
GO
/****** Object:  Trigger [dbo].[onCourseInsertDelete]    Script Date: 10/31/2023 1:26:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TRIGGER [dbo].[onCourseInsertDelete] ON [dbo].[Courses] FOR INSERT, DELETE
AS
	BEGIN
		IF EXISTS (SELECT * FROM inserted)
			BEGIN
				UPDATE Instructors SET CourseCount += 1 WHERE Id = (SELECT InstructorId FROM inserted);
				
				DECLARE @path VARCHAR(100);
				SELECT @path = Path FROM Categories WHERE Id = (SELECT LeafCategoryId FROM inserted);
				DECLARE @ids TABLE (Value UniqueIdentifier);
				INSERT INTO @ids (Value) SELECT CAST(value AS UniqueIdentifier) FROM STRING_SPLIT(@path, '_');
				UPDATE Categories SET CourseCount += 1 WHERE Id IN (SELECT * FROM @ids);
			END
		ELSE
			BEGIN
				UPDATE Instructors SET CourseCount -= 1 WHERE Id = (SELECT InstructorId FROM deleted);

				DECLARE @dpath VARCHAR(100);
				SELECT @dpath = Path FROM Categories WHERE Id = (SELECT LeafCategoryId FROM deleted);
				DECLARE @dids TABLE (Value UniqueIdentifier);
				INSERT INTO @ids (Value) SELECT CAST(value AS UniqueIdentifier) FROM STRING_SPLIT(@dpath, '_');
				UPDATE Categories SET CourseCount -= 1 WHERE Id IN (SELECT * FROM @dids);
			END
	END
GO
ALTER TABLE [dbo].[Courses] ENABLE TRIGGER [onCourseInsertDelete]
GO
/****** Object:  Trigger [dbo].[onEnrollmentInsertDelete]    Script Date: 10/31/2023 1:26:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[onEnrollmentInsertDelete] ON [dbo].[Enrollments] FOR INSERT, DELETE
AS
	BEGIN
		DECLARE @amount BigInt

		IF EXISTS (SELECT * FROM inserted)
			BEGIN
				UPDATE Users SET EnrollmentCount += 1 WHERE Id = (SELECT CreatorId FROM inserted);

				UPDATE Courses SET LearnerCount += 1 WHERE Id = (SELECT CourseId FROM inserted);

				SELECT @amount = (SELECT Amount FROM Bills JOIN inserted ON Bills.Id = inserted.BillId);
				UPDATE Users SET SystemBalance += @amount WHERE Id = (SELECT CreatorId FROM inserted);
				UPDATE Instructors SET Balance += @amount
					FROM Instructors INNER JOIN Courses ON Instructors.Id = Courses.InstructorId INNER JOIN inserted ON Courses.Id = inserted.CourseId;
			END
		ELSE
			BEGIN
				UPDATE Users SET EnrollmentCount -= 1 WHERE Id = (SELECT CreatorId FROM deleted);

				UPDATE Courses SET LearnerCount -= 1 WHERE Id = (SELECT CourseId FROM deleted);

				SELECT @amount = (SELECT Amount FROM Bills JOIN inserted ON Bills.Id = inserted.BillId);
				UPDATE Users SET SystemBalance -= @amount WHERE Id = (SELECT CreatorId FROM deleted);
				UPDATE Instructors SET Balance -= @amount
					FROM Instructors INNER JOIN Courses ON Instructors.Id = Courses.InstructorId INNER JOIN deleted ON Courses.Id = deleted.CourseId;
			END
	END
GO
ALTER TABLE [dbo].[Enrollments] ENABLE TRIGGER [onEnrollmentInsertDelete]
GO
/****** Object:  Trigger [dbo].[onLectureInsertDelete]    Script Date: 10/31/2023 1:26:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[onLectureInsertDelete] ON [dbo].[Lectures] FOR INSERT, DELETE
AS
	BEGIN
		DECLARE @sectionId UniqueIdentifier
		IF EXISTS (SELECT * FROM inserted)
			BEGIN
				SELECT @sectionId = SectionId FROM inserted;
				UPDATE Sections SET LectureCount += 1 WHERE Id = @sectionId;
				UPDATE Courses SET LectureCount +=1
					FROM Courses INNER JOIN Sections ON Courses.Id = Sections.CourseId
					WHERE Sections.CourseId = @sectionId;
			END
		ELSE
			BEGIN
				SELECT @sectionId = SectionId FROM deleted;
				UPDATE Sections SET LectureCount -= 1 WHERE Id = @sectionId;
				UPDATE Courses SET LectureCount -= 1
					FROM Courses INNER JOIN Sections ON Courses.Id = Sections.CourseId
					WHERE Sections.CourseId = @sectionId;
			END
	END
GO
ALTER TABLE [dbo].[Lectures] ENABLE TRIGGER [onLectureInsertDelete]
GO
USE [master]
GO
ALTER DATABASE [CourseHubDB] SET  READ_WRITE 
GO
