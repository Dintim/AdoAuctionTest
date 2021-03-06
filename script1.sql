USE [master]
GO
/****** Object:  Database [Auction.IdentityDb]    Script Date: 27.03.2019 21:49:23 ******/
CREATE DATABASE [Auction.IdentityDb]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Auction.IdentityDb', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Auction.IdentityDb.mdf' , SIZE = 4160KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'Auction.IdentityDb_log', FILENAME = N'c:\Program Files\Microsoft SQL Server\MSSQL11.SQLEXPRESS\MSSQL\DATA\Auction.IdentityDb_log.ldf' , SIZE = 1040KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [Auction.IdentityDb] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Auction.IdentityDb].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Auction.IdentityDb] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET ARITHABORT OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET AUTO_CLOSE ON 
GO
ALTER DATABASE [Auction.IdentityDb] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [Auction.IdentityDb] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Auction.IdentityDb] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Auction.IdentityDb] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET  ENABLE_BROKER 
GO
ALTER DATABASE [Auction.IdentityDb] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Auction.IdentityDb] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Auction.IdentityDb] SET  MULTI_USER 
GO
ALTER DATABASE [Auction.IdentityDb] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Auction.IdentityDb] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Auction.IdentityDb] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Auction.IdentityDb] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [Auction.IdentityDb]
GO
/****** Object:  Table [dbo].[ApplicationUserPasswordHistories]    Script Date: 27.03.2019 21:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationUserPasswordHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[ApplicationUserId] [uniqueidentifier] NOT NULL,
	[SetupDate] [datetime] NOT NULL,
	[InvalidatedDate] [datetime] NULL,
	[PasswordHash] [nvarchar](max) NOT NULL,
 CONSTRAINT [PK_dbo.ApplicationUserPasswordHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationUsers]    Script Date: 27.03.2019 21:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationUsers](
	[Id] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](max) NOT NULL,
	[IsActivatedAccount] [bit] NOT NULL,
	[FailedSignInCount] [int] NOT NULL,
	[IsBlockedBySystem] [bit] NOT NULL,
	[AssociatedEmployeeId] [uniqueidentifier] NOT NULL,
	[CreationDate] [datetime] NOT NULL,
 CONSTRAINT [PK_dbo.ApplicationUsers] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[ApplicationUserSignInHistories]    Script Date: 27.03.2019 21:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ApplicationUserSignInHistories](
	[Id] [uniqueidentifier] NOT NULL,
	[ApplicationUserId] [uniqueidentifier] NOT NULL,
	[SignInTime] [datetime] NOT NULL,
	[MachineIp] [nvarchar](max) NOT NULL,
	[IpToGeoCountryCode] [nvarchar](max) NULL,
	[IpToGeoCityName] [nvarchar](max) NULL,
	[IpToGeoLatitude] [decimal](18, 2) NOT NULL,
	[IpToGeoLongitude] [decimal](18, 2) NOT NULL,
 CONSTRAINT [PK_dbo.ApplicationUserSignInHistories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SmsActivationCodes]    Script Date: 27.03.2019 21:49:23 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SmsActivationCodes](
	[Id] [uniqueidentifier] NOT NULL,
	[ActivationCode] [nvarchar](max) NULL,
	[GeneratedTime] [datetime] NOT NULL,
	[AssociatedApplicationUserId] [uniqueidentifier] NOT NULL,
 CONSTRAINT [PK_dbo.SmsActivationCodes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

GO
INSERT [dbo].[ApplicationUserPasswordHistories] ([Id], [ApplicationUserId], [SetupDate], [InvalidatedDate], [PasswordHash]) VALUES (N'5a4cc605-25bd-45c0-88bd-11449da31ca7', N'93293056-df3a-4cf5-89b7-fd4332c560ae', CAST(0x0000AA1D00000000 AS DateTime), CAST(0x0000AA1D00000000 AS DateTime), N'qwerty')
INSERT [dbo].[ApplicationUserPasswordHistories] ([Id], [ApplicationUserId], [SetupDate], [InvalidatedDate], [PasswordHash]) VALUES (N'7fcf5645-da72-411e-a90f-2c5259bf9c39', N'93293056-df3a-4cf5-89b7-fd4332c560ae', CAST(0x0000AA1D00000000 AS DateTime), NULL, N'qwerty123')
INSERT [dbo].[ApplicationUsers] ([Id], [Email], [IsActivatedAccount], [FailedSignInCount], [IsBlockedBySystem], [AssociatedEmployeeId], [CreationDate]) VALUES (N'93293056-df3a-4cf5-89b7-fd4332c560ae', N'ddd@mail.ru', 1, 0, 0, N'7c8f362a-ed17-42fd-a733-9128ed13139c', CAST(0x0000AA1D00000000 AS DateTime))
INSERT [dbo].[ApplicationUserSignInHistories] ([Id], [ApplicationUserId], [SignInTime], [MachineIp], [IpToGeoCountryCode], [IpToGeoCityName], [IpToGeoLatitude], [IpToGeoLongitude]) VALUES (N'2ba50fc3-02d3-407c-9cf0-885cd597cad5', N'93293056-df3a-4cf5-89b7-fd4332c560ae', CAST(0x0000AA1D00000000 AS DateTime), N'5.76.221.49', N'Kazakhstan', N'Almaty', CAST(43.26 AS Decimal(18, 2)), CAST(76.92 AS Decimal(18, 2)))
USE [master]
GO
ALTER DATABASE [Auction.IdentityDb] SET  READ_WRITE 
GO
