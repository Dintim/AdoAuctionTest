USE [master]
GO
/****** Object:  Database [Auction.ApplicationDb]    Script Date: 27.03.2019 21:49:59 ******/
CREATE DATABASE [Auction.ApplicationDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Auction.ApplicationDb', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Auction.ApplicationDb.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Auction.ApplicationDb_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Auction.ApplicationDb_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Auction.ApplicationDb] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Auction.ApplicationDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Auction.ApplicationDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Auction.ApplicationDb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Auction.ApplicationDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Auction.ApplicationDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Auction.ApplicationDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Auction.ApplicationDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Auction.ApplicationDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Auction.ApplicationDb] SET  MULTI_USER 
GO
ALTER DATABASE [Auction.ApplicationDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Auction.ApplicationDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Auction.ApplicationDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Auction.ApplicationDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Auction.ApplicationDb]
GO
/****** Object:  Table [dbo].[EmployeeFileMetas]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeFileMetas](
	[Id] [uniqueidentifier] NOT NULL,
	[FileName] [nvarchar](max) NULL,
	[Extension] [nvarchar](max) NULL,
	[CreatedAt] [datetime] NOT NULL,
	[FolderId] [uniqueidentifier] NOT NULL,
	[S3StorageObjectId] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.EmployeeFileMetas] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeFolders]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeFolders](
	[Id] [uniqueidentifier] NOT NULL,
	[FolderName] [nvarchar](max) NULL,
	[EmployeeId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.EmployeeFolders] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeeRoles]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeeRoles](
	[Id] [uniqueidentifier] NOT NULL,
	[RoleName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.EmployeeRoles] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Employees]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Employees](
	[Id] [uniqueidentifier] NOT NULL,
	[FirstName] [nvarchar](max) NULL,
	[LastName] [nvarchar](max) NULL,
	[MiddleName] [nvarchar](max) NULL,
	[Email] [nvarchar](max) NULL,
	[DoB] [datetime] NULL,
	[OrganizationId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.Employees] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[EmployeesEmployeeRoles]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EmployeesEmployeeRoles](
	[EmployeeId] [uniqueidentifier] NOT NULL,
	[RoleId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.EmployeesEmployeeRoles] PRIMARY KEY CLUSTERED 
(
	[EmployeeId] ASC,
	[RoleId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Organizations]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Organizations](
	[Id] [uniqueidentifier] NOT NULL,
	[FullName] [nvarchar](max) NULL,
	[IdentificationNumber] [nvarchar](max) NULL,
	[RegistrationDate] [datetime] NOT NULL,
	[OrganizationTypeId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.Organizations] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[OrganizationTypes]    Script Date: 27.03.2019 21:49:59 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[OrganizationTypes](
	[Id] [uniqueidentifier] NOT NULL,
	[OrganizationTypeName] [nvarchar](max) NULL,
 CONSTRAINT [PK_dbo.OrganizationTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[EmployeeRoles] ([Id], [RoleName]) VALUES (N'39ab1b49-a458-4129-ab0a-930f8f92a0ae', N'CEO')
INSERT [dbo].[EmployeeRoles] ([Id], [RoleName]) VALUES (N'39da8aa6-d3fa-44b6-9c6d-e9c75f5d3486', N'Manager')
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [MiddleName], [Email], [DoB], [OrganizationId]) VALUES (N'ec615278-3968-46bc-a729-831606f40268', N'Иван', N'Иванов', N'Иванович', N'ccsharp@mail.ru', CAST(0x0000798300000000 AS DateTime), N'7490aaf3-d5af-41df-9835-787ec660808e')
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [MiddleName], [Email], [DoB], [OrganizationId]) VALUES (N'7c8f362a-ed17-42fd-a733-9128ed13139c', N'Руслан', N'Русланов', N'Русланович', N'ddd@mail.ru', CAST(0x000079CD00000000 AS DateTime), N'132ca812-354c-4f16-b6a0-5ddf44db14a1')
INSERT [dbo].[Employees] ([Id], [FirstName], [LastName], [MiddleName], [Email], [DoB], [OrganizationId]) VALUES (N'519b6039-6f26-4e2a-879b-9f1b06fa28b1', N'Динара', N'Мукашева', N'Баглановна', N'muk_dinara@mail.ru', CAST(0x000076F800000000 AS DateTime), N'1eefbc5f-e01b-4f24-8fd5-c9dfd9e1d504')
INSERT [dbo].[EmployeesEmployeeRoles] ([EmployeeId], [RoleId]) VALUES (N'ec615278-3968-46bc-a729-831606f40268', N'39ab1b49-a458-4129-ab0a-930f8f92a0ae')
INSERT [dbo].[EmployeesEmployeeRoles] ([EmployeeId], [RoleId]) VALUES (N'519b6039-6f26-4e2a-879b-9f1b06fa28b1', N'39ab1b49-a458-4129-ab0a-930f8f92a0ae')
INSERT [dbo].[EmployeesEmployeeRoles] ([EmployeeId], [RoleId]) VALUES (N'519b6039-6f26-4e2a-879b-9f1b06fa28b1', N'39da8aa6-d3fa-44b6-9c6d-e9c75f5d3486')
INSERT [dbo].[Organizations] ([Id], [FullName], [IdentificationNumber], [RegistrationDate], [OrganizationTypeId]) VALUES (N'04db6c22-61e7-4976-932e-49c9abc8e764', N'KEGOC', N'159753456', CAST(0x0000AA1D00000000 AS DateTime), N'87081655-d350-45c7-a6c5-8a51ede383af')
INSERT [dbo].[Organizations] ([Id], [FullName], [IdentificationNumber], [RegistrationDate], [OrganizationTypeId]) VALUES (N'7490aaf3-d5af-41df-9835-787ec660808e', N'КТЖ', N'123456789', CAST(0x00009E5E00000000 AS DateTime), N'87081655-d350-45c7-a6c5-8a51ede383af')
INSERT [dbo].[Organizations] ([Id], [FullName], [IdentificationNumber], [RegistrationDate], [OrganizationTypeId]) VALUES (N'1eefbc5f-e01b-4f24-8fd5-c9dfd9e1d504', N'Air Astana', N'789456123', CAST(0x00009CF100000000 AS DateTime), N'87081655-d350-45c7-a6c5-8a51ede383af')
INSERT [dbo].[Organizations] ([Id], [FullName], [IdentificationNumber], [RegistrationDate], [OrganizationTypeId]) VALUES (N'c5432a06-7f02-4af3-a07a-e04a20fadd6d', N'Самрук-Казына', N'456789123', CAST(0x00009FEE00000000 AS DateTime), N'87081655-d350-45c7-a6c5-8a51ede383af')
INSERT [dbo].[OrganizationTypes] ([Id], [OrganizationTypeName]) VALUES (N'87081655-d350-45c7-a6c5-8a51ede383af', N'АО')
INSERT [dbo].[OrganizationTypes] ([Id], [OrganizationTypeName]) VALUES (N'01d3e89a-bff2-4384-9979-8b1e06d8e67b', N'ТОО')
INSERT [dbo].[OrganizationTypes] ([Id], [OrganizationTypeName]) VALUES (N'0c21fb02-b05e-49d4-aae1-8fec03719ff1', N'ИП')
USE [master]
GO
ALTER DATABASE [Auction.ApplicationDb] SET  READ_WRITE 
GO
