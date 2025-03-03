USE [master]
GO
/****** Object:  Database [studentdatabase]    Script Date: 2/11/2020 2:41:47 PM ******/
CREATE DATABASE [studentdatabase]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'studentdatabase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\studentdatabase.mdf' , SIZE = 3072KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'studentdatabase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\studentdatabase_log.ldf' , SIZE = 4672KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [studentdatabase] SET COMPATIBILITY_LEVEL = 100
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [studentdatabase].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [studentdatabase] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [studentdatabase] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [studentdatabase] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [studentdatabase] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [studentdatabase] SET ARITHABORT OFF 
GO
ALTER DATABASE [studentdatabase] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [studentdatabase] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [studentdatabase] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [studentdatabase] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [studentdatabase] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [studentdatabase] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [studentdatabase] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [studentdatabase] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [studentdatabase] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [studentdatabase] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [studentdatabase] SET  DISABLE_BROKER 
GO
ALTER DATABASE [studentdatabase] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [studentdatabase] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [studentdatabase] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [studentdatabase] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [studentdatabase] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [studentdatabase] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [studentdatabase] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [studentdatabase] SET RECOVERY FULL 
GO
ALTER DATABASE [studentdatabase] SET  MULTI_USER 
GO
ALTER DATABASE [studentdatabase] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [studentdatabase] SET DB_CHAINING OFF 
GO
ALTER DATABASE [studentdatabase] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [studentdatabase] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
EXEC sys.sp_db_vardecimal_storage_format N'studentdatabase', N'ON'
GO
USE [studentdatabase]
GO
/****** Object:  StoredProcedure [dbo].[bindddlclass]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[bindddlclass]
as
begin
  select * from classmaster where status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[bindddlstudents]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[bindddlstudents]
as
begin
select s.uid,CONCAT(s.name,' ',s.lastname,' -- ',c.classname) as name from Students s
inner join classmaster c on s.classid=c.classid 
where s.status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[bindddlsubjects]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[bindddlsubjects]
as
begin
  select * from subjectmaster where status='A'
end
GO
/****** Object:  StoredProcedure [dbo].[bindgridfilter]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE procedure [dbo].[bindgridfilter]
@id int,
@classorsubid int
as
begin
if(@id=1)
begin
select ss.id ,s.name	,s.Lastname,sm.subjectname,cm.classname,ss.marks from studentdatabase.dbo.StudentSubjects ss
inner join Students s on ss.studid=s.uid
inner join subjectmaster sm on ss.subjectid=sm.subjectid
inner join classmaster cm on s.classid=cm.classid
where ss.status='A' and s.status='A' and s.classid=@classorsubid
end
 if(@id=2)
 begin
 select ss.id ,s.name	,s.Lastname,sm.subjectname,cm.classname,ss.marks from studentdatabase.dbo.StudentSubjects ss
inner join Students s on ss.studid=s.uid
inner join subjectmaster sm on ss.subjectid=sm.subjectid
inner join classmaster cm on s.classid=cm.classid
where ss.status='A' and s.status='A' and ss.subjectid=@classorsubid
 end

end
GO
/****** Object:  StoredProcedure [dbo].[insert_studentsubjectmarks]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

  CREATE procedure [dbo].[insert_studentsubjectmarks]
  @studid int,
  --@classid int,
  @subjectid int,
  @marks int ,
  @inupid int,
 @returnval int output,
 @uniqueid int
  as
  begin
  if(@inupid=1)
begin
if exists(select * from  [studentdatabase].[dbo].[StudentSubjects] where studid=@studid  and subjectid=@subjectid and status='A'  )
begin
set @returnval=2
return @returnval
end
else
begin
 insert into  [studentdatabase].[dbo].[StudentSubjects] (studid,subjectid,marks,status) values (@studid,@subjectid,@marks,'A')
set @returnval=1
return @returnval
end
end
if(@inupid=2)
begin
select ss.id ,s.name	,s.Lastname,sm.subjectname,cm.classname,ss.marks from studentdatabase.dbo.StudentSubjects ss
inner join Students s on ss.studid=s.uid
inner join subjectmaster sm on ss.subjectid=sm.subjectid
inner join classmaster cm on s.classid=cm.classid
where ss.status='A' and s.status='A'
end

  if(@inupid=3)
  begin
  select * from StudentSubjects   where id=@uniqueid
  end

     if(@inupid=4)
  begin

update studentdatabase.dbo.StudentSubjects set marks=@marks where id=@uniqueid
set @returnval=1
return @returnval


end
  

    if(@inupid=5)
  begin
update StudentSubjects set status='D'  where id=@uniqueid
  set @returnval=1
return @returnval
  end

  end
GO
/****** Object:  StoredProcedure [dbo].[inup_students]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
--select * from students
CREATE  procedure [dbo].[inup_students]
@fname varchar(50),
@lname varchar(50),
@classid int,

@inupid int,
@returnval int output,
@uniqueid int

as
begin
if(@inupid=1)
begin

 insert into studentdatabase.dbo.students(name,LastName,classid,status) 
 values(@fname,@lname,@classid,'A')
set @returnval=1
return @returnval

end

if(@inupid=2)
begin
select s.uid as id,s.name,s.LastName,cm.classname from studentdatabase.dbo.students s
inner join studentdatabase.dbo.classmaster cm on s.classid=cm.classid 
where s.status='A'
 end  
  if(@inupid=3)
  begin
  select * from studentdatabase.dbo.Students  where uid=@uniqueid
  end
  -- if(@inupid=4)
  --begin

  --end

  if(@inupid=5)
  begin
update studentdatabase.dbo.Students set status='D'  where uid=@uniqueid
update studentdatabase.dbo.StudentSubjects set status='D' where studid=@uniqueid
  set @returnval=1
return @returnval
  end

end



GO
/****** Object:  Table [dbo].[classmaster]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[classmaster](
	[classid] [int] IDENTITY(1,1) NOT NULL,
	[classname] [varchar](50) NULL,
	[status] [varchar](10) NULL,
 CONSTRAINT [PK_classmaster] PRIMARY KEY CLUSTERED 
(
	[classid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[Students]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Students](
	[uid] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NULL,
	[LastName] [varchar](50) NULL,
	[dob] [date] NULL,
	[father] [varchar](50) NULL,
	[mother] [varchar](50) NULL,
	[gender] [varchar](50) NULL,
	[classid] [int] NULL,
	[status] [varchar](10) NULL,
 CONSTRAINT [PK_Students] PRIMARY KEY CLUSTERED 
(
	[uid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[StudentSubjects]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[StudentSubjects](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[studid] [int] NULL,
	[classid] [int] NULL,
	[subjectid] [int] NULL,
	[marks] [float] NULL,
	[status] [varchar](10) NULL,
 CONSTRAINT [PK_StudentSubjects] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[subjectmaster]    Script Date: 2/11/2020 2:41:47 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[subjectmaster](
	[subjectid] [int] IDENTITY(1,1) NOT NULL,
	[subjectname] [varchar](50) NULL,
	[status] [varchar](10) NULL,
 CONSTRAINT [PK_subjectmaster] PRIMARY KEY CLUSTERED 
(
	[subjectid] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[classmaster] ON 

INSERT [dbo].[classmaster] ([classid], [classname], [status]) VALUES (1, N'B.Sc(NM)', N'A')
INSERT [dbo].[classmaster] ([classid], [classname], [status]) VALUES (2, N'B.Sc(Med)', N'A')
INSERT [dbo].[classmaster] ([classid], [classname], [status]) VALUES (3, N'BCA', N'A')
INSERT [dbo].[classmaster] ([classid], [classname], [status]) VALUES (4, N'BBA', N'A')
INSERT [dbo].[classmaster] ([classid], [classname], [status]) VALUES (5, N'B.Com', N'A')
SET IDENTITY_INSERT [dbo].[classmaster] OFF
SET IDENTITY_INSERT [dbo].[Students] ON 

INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (1, N'Amandeep', N'Singh', CAST(0x911A0B00 AS Date), N'Gurpreet', N'Harpreet', N'M', 1, N'D')
INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (2, N'Ravinder', N'Singh', CAST(0xEC180B00 AS Date), N'Harwinder', N'Kamal', N'M', 1, N'D')
INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (3, N'Pooja', N'Bansal', CAST(0x0A1B0B00 AS Date), N'Ram', N'Sita', N'F', 2, N'A')
INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (4, N'Jyoti', N'Arora', CAST(0x8D190B00 AS Date), N'Prakash', N'Noor', N'F', 2, N'A')
INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (5, N'simpy', N'Bansal', NULL, NULL, NULL, NULL, 1, N'A')
INSERT [dbo].[Students] ([uid], [name], [LastName], [dob], [father], [mother], [gender], [classid], [status]) VALUES (6, N'simpy', N'Bansal', NULL, NULL, NULL, NULL, 1, N'A')
SET IDENTITY_INSERT [dbo].[Students] OFF
SET IDENTITY_INSERT [dbo].[StudentSubjects] ON 

INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (1, 1, NULL, 1, 1200, N'D')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (2, 1, NULL, 2, 1220, N'A')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (3, 1, NULL, 3, 122, N'A')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (4, 1, NULL, 4, 12, N'A')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (5, 2, NULL, 2, 12, N'D')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (6, 0, NULL, 0, 12, N'A')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (7, 3, NULL, 3, 12, N'A')
INSERT [dbo].[StudentSubjects] ([id], [studid], [classid], [subjectid], [marks], [status]) VALUES (8, 3, NULL, 1, 12, N'A')
SET IDENTITY_INSERT [dbo].[StudentSubjects] OFF
SET IDENTITY_INSERT [dbo].[subjectmaster] ON 

INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (1, N'English', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (2, N'Punjabi', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (3, N'Maths', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (4, N'Computer Science', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (5, N'Chemistry', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (6, N'Physics', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (7, N'Biology', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (8, N'Accounting', N'A')
INSERT [dbo].[subjectmaster] ([subjectid], [subjectname], [status]) VALUES (9, N'Business Administration', N'A')
SET IDENTITY_INSERT [dbo].[subjectmaster] OFF
USE [master]
GO
ALTER DATABASE [studentdatabase] SET  READ_WRITE 
GO
