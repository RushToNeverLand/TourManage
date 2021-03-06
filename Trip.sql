USE [master]
GO
/****** Object:  Database [Trip]    Script Date: 2018/6/13 11:29:12 ******/
CREATE DATABASE [Trip]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'Trip', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Trip.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Trip_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Trip_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [Trip] SET COMPATIBILITY_LEVEL = 140
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [Trip].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [Trip] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [Trip] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [Trip] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [Trip] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [Trip] SET ARITHABORT OFF 
GO
ALTER DATABASE [Trip] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [Trip] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [Trip] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [Trip] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [Trip] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [Trip] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [Trip] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [Trip] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [Trip] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [Trip] SET  DISABLE_BROKER 
GO
ALTER DATABASE [Trip] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [Trip] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [Trip] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [Trip] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [Trip] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [Trip] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [Trip] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [Trip] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [Trip] SET  MULTI_USER 
GO
ALTER DATABASE [Trip] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [Trip] SET DB_CHAINING OFF 
GO
ALTER DATABASE [Trip] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [Trip] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [Trip] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [Trip] SET QUERY_STORE = OFF
GO
USE [Trip]
GO
ALTER DATABASE SCOPED CONFIGURATION SET IDENTITY_CACHE = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [Trip]
GO
/****** Object:  Table [dbo].[带队记录]    Script Date: 2018/6/13 11:29:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[带队记录](
	[旅游团号] [varchar](20) NOT NULL,
	[导游编号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_带队记录] PRIMARY KEY CLUSTERED 
(
	[旅游团号] ASC,
	[导游编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[已处理记录]    Script Date: 2018/6/13 11:29:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[已处理记录](
	[旅游团号] [varchar](20) NOT NULL,
	[导游编号] [varchar](20) NOT NULL,
	[导游级别] [int] NOT NULL,
 CONSTRAINT [PK_已处理记录] PRIMARY KEY CLUSTERED 
(
	[旅游团号] ASC,
	[导游编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[线路]    Script Date: 2018/6/13 11:29:12 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[线路](
	[线路号] [varchar](20) NOT NULL,
	[线路名称] [nvarchar](20) NOT NULL,
	[线路说明] [nvarchar](50) NULL,
 CONSTRAINT [PK_线路] PRIMARY KEY CLUSTERED 
(
	[线路号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[线路安排]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[线路安排](
	[旅游团号] [varchar](20) NOT NULL,
	[线路编号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_线路安排] PRIMARY KEY CLUSTERED 
(
	[旅游团号] ASC,
	[线路编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[线路_统计]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[线路_统计] as ((
		select 线路.线路号,线路.线路名称,count(*) as 次数 from 线路,线路安排,带队记录
		where 线路.线路号=线路安排.线路编号 and 线路安排.旅游团号=带队记录.旅游团号
		group by all 线路.线路号,线路.线路名称
	) union all(
		select 线路.线路号,线路.线路名称,count(*) as 次数 from 线路,线路安排,已处理记录
		where 线路.线路号=线路安排.线路编号 and 线路安排.旅游团号=已处理记录.旅游团号
		group by all 线路.线路号,线路.线路名称
	)
)
GO
/****** Object:  View [dbo].[热门线路]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[热门线路] as(
    select top 5 线路_统计.线路名称,线路_统计.次数 from 线路_统计 where 次数>0 order by 次数
)
GO
/****** Object:  Table [dbo].[导游]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[导游](
	[导游编号] [varchar](20) NOT NULL,
	[导游姓名] [nvarchar](20) NOT NULL,
	[性别] [nvarchar](8) NOT NULL,
	[入职日期] [date] NOT NULL,
	[级别] [int] NOT NULL,
	[积分] [int] NOT NULL,
 CONSTRAINT [PK_导游] PRIMARY KEY CLUSTERED 
(
	[导游编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[金牌导游]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[金牌导游] as(
    select top 5 导游.导游姓名,导游.级别 from 导游
    order by 导游.级别 desc
)
GO
/****** Object:  Table [dbo].[旅游团]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[旅游团](
	[团号] [varchar](20) NOT NULL,
	[团名] [nvarchar](50) NOT NULL,
	[人数限制] [int] NOT NULL,
	[报价] [money] NOT NULL,
	[组团日期] [date] NOT NULL,
	[开始日期] [date] NOT NULL,
	[结束日期] [date] NOT NULL,
 CONSTRAINT [PK_旅游团] PRIMARY KEY CLUSTERED 
(
	[团号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[旅游团和相关线路信息]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[旅游团和相关线路信息] as (
	select 旅游团.团号,旅游团.团名,旅游团.报价,线路.线路名称 from 旅游团,线路安排,线路 
	where  旅游团.团号=线路安排.旅游团号 and 线路安排.线路编号=线路.线路号
)
GO
/****** Object:  Table [dbo].[景点]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[景点](
	[景点编号] [varchar](20) NOT NULL,
	[景点名称] [nvarchar](50) NOT NULL,
	[所在地] [nvarchar](30) NOT NULL,
	[级别] [int] NOT NULL,
	[电话] [varchar](20) NOT NULL,
	[票价] [money] NOT NULL,
 CONSTRAINT [PK_景点] PRIMARY KEY CLUSTERED 
(
	[景点编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[景点安排]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[景点安排](
	[景点编号] [varchar](20) NOT NULL,
	[线路编号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_景点安排] PRIMARY KEY CLUSTERED 
(
	[景点编号] ASC,
	[线路编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  View [dbo].[景点_统计]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[景点_统计] as ((
		select 景点.景点名称,景点.所在地,count(*) as 次数 from 景点,景点安排,线路安排,带队记录
		where 景点.景点编号=景点安排.景点编号 and 景点安排.线路编号=线路安排.线路编号 and 线路安排.旅游团号=带队记录.旅游团号
		group by all 景点.景点名称,景点.所在地
	) union all(
		select 景点.景点名称,景点.所在地,count(*) as 次数 from 景点,景点安排,线路安排,已处理记录
		where 景点.景点编号=景点安排.景点编号 and 景点安排.线路编号=线路安排.线路编号 and 线路安排.旅游团号=已处理记录.旅游团号
		group by all 景点.景点名称,景点.所在地
	)
)
GO
/****** Object:  View [dbo].[热门景点]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create view [dbo].[热门景点] as(
	select top 5 * from 景点_统计 where 次数>0 order by 次数
)
GO
/****** Object:  Table [dbo].[manager]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[manager](
	[id] [varchar](20) NOT NULL,
	[pwd] [varchar](20) NOT NULL,
 CONSTRAINT [PK_manager] PRIMARY KEY CLUSTERED 
(
	[id] ASC,
	[pwd] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[orde]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[orde](
	[旅游团号] [varchar](20) NOT NULL,
	[游客身份证号] [varchar](20) NOT NULL,
	[缴纳费用] [money] NOT NULL,
 CONSTRAINT [PK_Table_1] PRIMARY KEY CLUSTERED 
(
	[旅游团号] ASC,
	[游客身份证号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[宾馆]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[宾馆](
	[宾馆编号] [varchar](20) NOT NULL,
	[宾馆名称] [nvarchar](50) NOT NULL,
	[星级] [int] NOT NULL,
	[标准房价] [money] NOT NULL,
	[电话] [varchar](30) NOT NULL,
 CONSTRAINT [PK_宾馆] PRIMARY KEY CLUSTERED 
(
	[宾馆编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[宾馆安排]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[宾馆安排](
	[宾馆编号] [varchar](20) NOT NULL,
	[线路编号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_宾馆安排] PRIMARY KEY CLUSTERED 
(
	[宾馆编号] ASC,
	[线路编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[参团群体]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[参团群体](
	[群体编号] [varchar](20) NOT NULL,
	[旅游团编号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_参团群体] PRIMARY KEY CLUSTERED 
(
	[群体编号] ASC,
	[旅游团编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[参团游客]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[参团游客](
	[旅游团号] [varchar](20) NOT NULL,
	[游客身份证号] [varchar](20) NOT NULL,
	[缴纳费用] [int] NOT NULL,
 CONSTRAINT [PK_参团游客] PRIMARY KEY CLUSTERED 
(
	[旅游团号] ASC,
	[游客身份证号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[群体]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[群体](
	[群体编号] [varchar](20) NOT NULL,
	[备注信息] [nvarchar](80) NOT NULL,
 CONSTRAINT [PK_群体_1] PRIMARY KEY CLUSTERED 
(
	[群体编号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[所属群体]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[所属群体](
	[群体编号] [varchar](20) NOT NULL,
	[游客身份证号] [varchar](20) NOT NULL,
 CONSTRAINT [PK_所属群体] PRIMARY KEY CLUSTERED 
(
	[群体编号] ASC,
	[游客身份证号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[游客]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[游客](
	[身份证号] [varchar](20) NOT NULL,
	[游客姓名] [nvarchar](10) NOT NULL,
	[性别] [nvarchar](8) NOT NULL,
	[民族] [nvarchar](10) NOT NULL,
	[手机号] [varchar](20) NOT NULL,
	[紧急联系人] [nvarchar](10) NULL,
	[紧急联系号码] [varchar](20) NULL,
	[密码] [varchar](25) NOT NULL,
 CONSTRAINT [PK_游客] PRIMARY KEY CLUSTERED 
(
	[身份证号] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[导游] ADD  CONSTRAINT [DF__导游__积分__2FCF1A8A]  DEFAULT ((0)) FOR [积分]
GO
ALTER TABLE [dbo].[orde]  WITH CHECK ADD  CONSTRAINT [FK_order_旅游团] FOREIGN KEY([旅游团号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[orde] CHECK CONSTRAINT [FK_order_旅游团]
GO
ALTER TABLE [dbo].[orde]  WITH CHECK ADD  CONSTRAINT [FK_order_游客] FOREIGN KEY([游客身份证号])
REFERENCES [dbo].[游客] ([身份证号])
GO
ALTER TABLE [dbo].[orde] CHECK CONSTRAINT [FK_order_游客]
GO
ALTER TABLE [dbo].[宾馆安排]  WITH CHECK ADD  CONSTRAINT [FK_宾馆安排_宾馆] FOREIGN KEY([宾馆编号])
REFERENCES [dbo].[宾馆] ([宾馆编号])
GO
ALTER TABLE [dbo].[宾馆安排] CHECK CONSTRAINT [FK_宾馆安排_宾馆]
GO
ALTER TABLE [dbo].[宾馆安排]  WITH CHECK ADD  CONSTRAINT [FK_宾馆安排_线路] FOREIGN KEY([线路编号])
REFERENCES [dbo].[线路] ([线路号])
GO
ALTER TABLE [dbo].[宾馆安排] CHECK CONSTRAINT [FK_宾馆安排_线路]
GO
ALTER TABLE [dbo].[参团群体]  WITH CHECK ADD  CONSTRAINT [FK_参团群体_旅游团] FOREIGN KEY([旅游团编号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[参团群体] CHECK CONSTRAINT [FK_参团群体_旅游团]
GO
ALTER TABLE [dbo].[参团群体]  WITH CHECK ADD  CONSTRAINT [FK_参团群体_群体] FOREIGN KEY([群体编号])
REFERENCES [dbo].[群体] ([群体编号])
GO
ALTER TABLE [dbo].[参团群体] CHECK CONSTRAINT [FK_参团群体_群体]
GO
ALTER TABLE [dbo].[参团游客]  WITH CHECK ADD  CONSTRAINT [FK_参团游客_旅游团] FOREIGN KEY([旅游团号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[参团游客] CHECK CONSTRAINT [FK_参团游客_旅游团]
GO
ALTER TABLE [dbo].[参团游客]  WITH CHECK ADD  CONSTRAINT [FK_参团游客_游客] FOREIGN KEY([游客身份证号])
REFERENCES [dbo].[游客] ([身份证号])
GO
ALTER TABLE [dbo].[参团游客] CHECK CONSTRAINT [FK_参团游客_游客]
GO
ALTER TABLE [dbo].[带队记录]  WITH CHECK ADD  CONSTRAINT [FK_带队记录_导游] FOREIGN KEY([导游编号])
REFERENCES [dbo].[导游] ([导游编号])
GO
ALTER TABLE [dbo].[带队记录] CHECK CONSTRAINT [FK_带队记录_导游]
GO
ALTER TABLE [dbo].[带队记录]  WITH CHECK ADD  CONSTRAINT [FK_带队记录_旅游团] FOREIGN KEY([旅游团号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[带队记录] CHECK CONSTRAINT [FK_带队记录_旅游团]
GO
ALTER TABLE [dbo].[景点安排]  WITH CHECK ADD  CONSTRAINT [FK_景点安排_景点] FOREIGN KEY([景点编号])
REFERENCES [dbo].[景点] ([景点编号])
GO
ALTER TABLE [dbo].[景点安排] CHECK CONSTRAINT [FK_景点安排_景点]
GO
ALTER TABLE [dbo].[景点安排]  WITH CHECK ADD  CONSTRAINT [FK_景点安排_线路] FOREIGN KEY([线路编号])
REFERENCES [dbo].[线路] ([线路号])
GO
ALTER TABLE [dbo].[景点安排] CHECK CONSTRAINT [FK_景点安排_线路]
GO
ALTER TABLE [dbo].[所属群体]  WITH CHECK ADD  CONSTRAINT [FK_所属群体_群体] FOREIGN KEY([群体编号])
REFERENCES [dbo].[群体] ([群体编号])
GO
ALTER TABLE [dbo].[所属群体] CHECK CONSTRAINT [FK_所属群体_群体]
GO
ALTER TABLE [dbo].[所属群体]  WITH CHECK ADD  CONSTRAINT [FK_所属群体_游客] FOREIGN KEY([游客身份证号])
REFERENCES [dbo].[游客] ([身份证号])
GO
ALTER TABLE [dbo].[所属群体] CHECK CONSTRAINT [FK_所属群体_游客]
GO
ALTER TABLE [dbo].[线路安排]  WITH CHECK ADD  CONSTRAINT [FK_线路安排_旅游团] FOREIGN KEY([旅游团号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[线路安排] CHECK CONSTRAINT [FK_线路安排_旅游团]
GO
ALTER TABLE [dbo].[线路安排]  WITH CHECK ADD  CONSTRAINT [FK_线路安排_线路] FOREIGN KEY([线路编号])
REFERENCES [dbo].[线路] ([线路号])
GO
ALTER TABLE [dbo].[线路安排] CHECK CONSTRAINT [FK_线路安排_线路]
GO
ALTER TABLE [dbo].[已处理记录]  WITH CHECK ADD  CONSTRAINT [FK_已处理记录_导游] FOREIGN KEY([导游编号])
REFERENCES [dbo].[导游] ([导游编号])
GO
ALTER TABLE [dbo].[已处理记录] CHECK CONSTRAINT [FK_已处理记录_导游]
GO
ALTER TABLE [dbo].[已处理记录]  WITH CHECK ADD  CONSTRAINT [FK_已处理记录_旅游团] FOREIGN KEY([旅游团号])
REFERENCES [dbo].[旅游团] ([团号])
GO
ALTER TABLE [dbo].[已处理记录] CHECK CONSTRAINT [FK_已处理记录_旅游团]
GO
/****** Object:  StoredProcedure [dbo].[orde_加入游客记录]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[orde_加入游客记录]
    @P1 varchar(20),
	@P2 varchar(20)
as begin
	declare @缴纳费用 money;
	select @缴纳费用=orde.缴纳费用 from orde where orde.旅游团号=@P1 and orde.游客身份证号 = @P2
	insert into 参团游客 values(@P1,@P2,@缴纳费用)
	delete from orde where 旅游团号=@P1 and 游客身份证号 = @P2
end
GO
/****** Object:  StoredProcedure [dbo].[查询列名]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[查询列名]
	@P1 char(40)
as begin
	declare @objid int
	select @objid = id from sysobjects where id = object_id(@P1)
	select 'Column_name' = name from syscolumns where id = @objid order by colid  
end
GO
/****** Object:  StoredProcedure [dbo].[城市_推荐旅游团]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[城市_推荐旅游团]
@P1 varchar(20)
as begin
	select 旅游团.团名,旅游团.人数限制,旅游团.报价,旅游团.组团日期,旅游团.开始日期,旅游团.结束日期 from 景点,景点安排,线路安排,旅游团
	where 景点.所在地 like '%'+@P1+'%' and 景点.景点编号=景点安排.景点编号 and 景点安排.线路编号 = 线路安排.线路编号 and 线路安排.旅游团号 = 旅游团.团号
end
GO
/****** Object:  StoredProcedure [dbo].[带队记录_更新导游业绩]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[带队记录_更新导游业绩]
    @P1 varchar(20)
as begin
    declare @总人数 int,@总收入 int;
    select @总人数=count(*),@总收入=sum(参团游客.缴纳费用) from 旅游团,带队记录,参团游客
    where 带队记录.导游编号=@P1 and 带队记录.旅游团号=旅游团.团号 and 参团游客.旅游团号=旅游团.团号;
    update 导游 set 导游.积分=导游.积分+(@总收入/1000) where 导游.导游编号=@P1;
    
    with X as (
        select 带队记录.旅游团号,带队记录.导游编号,级别=导游.级别 from 带队记录,导游 where 带队记录.导游编号=@P1 and 导游.导游编号=@P1
    )
    insert into 已处理记录 select * from X
    delete from 带队记录 where 带队记录.导游编号=@P1
end
GO
/****** Object:  StoredProcedure [dbo].[带队记录_更新业绩]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[带队记录_更新业绩]
as begin
    declare 选取编号 scroll cursor for select 导游编号 from 带队记录
    open 选取编号
    declare @导游编号 varchar(20)
    fetch next from 选取编号 into @导游编号
    while(@@fetch_status=0)
    begin
        exec 带队记录_更新导游业绩 @P1=@导游编号
        fetch next from 选取编号 into @导游编号
    end
    close 选取编号
end
GO
/****** Object:  StoredProcedure [dbo].[景点_关联线路]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[景点_关联线路]
@P1 varchar(20)
as begin
    select 线路.线路名称,线路.线路说明 from 景点,景点安排,线路
    where 景点.景点名称 like '%'+@P1+'%' and 景点.景点编号=景点安排.景点编号 and 景点安排.线路编号=线路.线路号
end
GO
/****** Object:  StoredProcedure [dbo].[景点_搜索所在地]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[景点_搜索所在地]
@P1 varchar(20)
as begin
	select 景点.景点名称,景点.级别,景点.票价 from 景点
	where 景点.所在地=@P1
end
GO
/****** Object:  StoredProcedure [dbo].[景点_推荐旅游团]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[景点_推荐旅游团]
@P1 varchar(20)
as begin
	select 旅游团.团名,旅游团.人数限制,旅游团.报价,旅游团.组团日期,旅游团.开始日期,旅游团.结束日期 from 景点,景点安排,线路安排,旅游团
	where 景点.景点名称 like '%'+@P1+'%' and 景点.景点编号=景点安排.景点编号 and 景点安排.线路编号 = 线路安排.线路编号 and 线路安排.旅游团号 = 旅游团.团号
end
GO
/****** Object:  StoredProcedure [dbo].[老顾客统计]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[老顾客统计]
as begin
	with X as(
		select 游客.身份证号,sum(参团游客.缴纳费用) as 总消费,count(*) as 消费次数 from 游客,参团游客
		where 游客.身份证号=参团游客.游客身份证号
		group by 游客.身份证号)
	select X.身份证号,游客.游客姓名,游客.民族,游客.手机号,X.总消费,X.消费次数 from X,游客 where X.身份证号=游客.身份证号 order by X.总消费 desc
end 
GO
/****** Object:  StoredProcedure [dbo].[搜索线路内容]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create proc [dbo].[搜索线路内容]
@P1 varchar(20)
as begin
	select 景点.景点名称,景点.所在地,景点.级别 from 景点,景点安排,线路
	where 线路.线路名称=@P1 and 线路.线路号=景点安排.线路编号 and 景点安排.景点编号=景点.景点编号
end
GO
/****** Object:  Trigger [dbo].[宾馆信息_插入信息]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[宾馆信息_插入信息] on [dbo].[宾馆] after insert
as begin
	declare @星级 int,@票价 money
	select @星级=星级,@票价=标准房价 from inserted
	if ((@星级=1 and @票价<200) or (@星级=2 and @票价<300) or (@星级=3 and @票价<500))
	begin
		print '票价不符合星级'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[宾馆] ENABLE TRIGGER [宾馆信息_插入信息]
GO
/****** Object:  Trigger [dbo].[参团游客_老顾客优惠]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[参团游客_老顾客优惠] on [dbo].[参团游客] instead of insert
as begin
	declare @游客身份证号 varchar(20),@消费次数 int,@总消费 int,@旅游团号 varchar(20),@缴纳费用 money
	select @游客身份证号=游客身份证号,@旅游团号=旅游团号,@缴纳费用=缴纳费用 from inserted
	select @消费次数=count(*),@总消费=sum(参团游客.缴纳费用) from 参团游客 where 参团游客.游客身份证号=@游客身份证号
	if(@消费次数>0)
	begin
		insert into 参团游客 values(@旅游团号,@游客身份证号,@缴纳费用*0.95)
	end
end
GO
ALTER TABLE [dbo].[参团游客] ENABLE TRIGGER [参团游客_老顾客优惠]
GO
/****** Object:  Trigger [dbo].[参团游客_人数限制]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[参团游客_人数限制] on [dbo].[参团游客] after insert
as begin
	declare @人数 int,@身份证号 varchar(20),@旅游团号 varchar(20),@人数限制 int
	select @身份证号=游客身份证号,@旅游团号=旅游团号 from inserted
	set @人数=(select count(*) from 参团游客 where 游客身份证号=@身份证号)
	set @人数限制=(select 人数限制 from 旅游团 where 团号=@旅游团号)
	if (@人数>@人数限制)
	begin
		print '人数已超出目标旅行团的人数限制，失败！'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[参团游客] ENABLE TRIGGER [参团游客_人数限制]
GO
/****** Object:  Trigger [dbo].[插入导游_级别限定]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[插入导游_级别限定] on [dbo].[导游] after insert
as begin
	declare @级别 int,@入职日期 date,@工龄 int
	select @级别=级别, @入职日期=入职日期 from inserted
	set @工龄=datediff(yy,@入职日期,getdate())
	if (@级别=1 and @工龄<3)
	begin
		print '工龄不满3年，级别不能到1'
		rollback transaction
	end
	if (@级别=2 and @工龄<5)
	begin
		print '工龄不满5年，级别不能到2'
		rollback transaction
	end
	if (@级别=3 and @工龄<10)
	begin
		print '工龄不满10年，级别不能到3'
		rollback transaction
	end
	if (@级别=4 and @工龄<15)
	begin
		print '工龄不满10年，级别不能到3'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[导游] ENABLE TRIGGER [插入导游_级别限定]
GO
/****** Object:  Trigger [dbo].[导游_更新积分]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[导游_更新积分] on [dbo].[导游]
instead of update
as begin
	declare @积分 int,@级别 int,@导游编号 varchar(20),@导游姓名 nvarchar(20),@性别 varchar(8),@入职日期 date
	select @导游编号=导游编号,@导游姓名=导游姓名,@性别=性别,@入职日期=入职日期,@级别=级别,@积分=积分 from inserted;
	if (@积分 >= 100)
	begin
		delete from 导游 where 导游编号 = @导游编号
		insert into 导游 values(@导游编号,@导游姓名,@性别,@入职日期,@级别+1,@积分-100)
	end
end
GO
ALTER TABLE [dbo].[导游] ENABLE TRIGGER [导游_更新积分]
GO
/****** Object:  Trigger [dbo].[导游_性别检查]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[导游_性别检查] on [dbo].[导游] after insert
as begin
	declare @性别 nvarchar(8)
	select @性别=性别 from inserted
	if @性别!='男' and @性别!='女'
	begin
		print '导游性别不符合规范'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[导游] ENABLE TRIGGER [导游_性别检查]
GO
/****** Object:  Trigger [dbo].[旅游团_日期检查]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[旅游团_日期检查] on [dbo].[旅游团] after insert
as begin
	declare @组团日期 date,@开始日期 date,@结束日期 date
	select @组团日期=组团日期,@开始日期=开始日期,@结束日期=结束日期 from inserted
	if (@组团日期>@开始日期 or @开始日期>@结束日期)
	begin
		print '日期不符合规范！'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[旅游团] ENABLE TRIGGER [旅游团_日期检查]
GO
/****** Object:  Trigger [dbo].[插入游客_检查紧急联系人]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[插入游客_检查紧急联系人] on [dbo].[游客] after insert
as begin
	declare @身份证号 varchar(20),@紧急联系人 nvarchar(10),@紧急联系号码 varchar(20),@出生日期 date,@年龄 int
	select @身份证号=身份证号,@紧急联系人=紧急联系人,@紧急联系号码=紧急联系号码,@出生日期=cast(substring(身份证号,7,8) as date) from inserted	
	set @年龄 = datediff(yy,@出生日期,getdate())
	if (len(@身份证号)<>18)
	begin
		print '请输入18位身份证号码'
		rollback transaction
	end
	if (@年龄<18 or @年龄>60)  and ( @紧急联系人 is null or @紧急联系号码 is null)
	begin
		print '年龄小于18或者年龄大于60的游客必须要输入紧急联系人和紧急联系号码'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[游客] ENABLE TRIGGER [插入游客_检查紧急联系人]
GO
/****** Object:  Trigger [dbo].[游客_性别检查]    Script Date: 2018/6/13 11:29:13 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create trigger [dbo].[游客_性别检查] on [dbo].[游客] after insert
as begin
	declare @性别 nvarchar(8)
	select @性别=性别 from inserted
	if @性别!='男' and @性别!='女'
	begin
		print '游客性别不符合规范'
		rollback transaction
	end
end
GO
ALTER TABLE [dbo].[游客] ENABLE TRIGGER [游客_性别检查]
GO
USE [master]
GO
ALTER DATABASE [Trip] SET  READ_WRITE 
GO
