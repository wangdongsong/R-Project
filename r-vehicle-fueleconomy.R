#练习：汽车数据的可视化分析

#数据源：http://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip
#数据源说明：http://www.fueleconomy.gov/feg/ws/index.shtml#vehicle

#加载所需要的R包
library(plyr, lib.loc = "E:/RPackage")
library(ggplot2, lib.loc = "E:/RPackage")
library(reshape2, lib.loc = "E:/RPackage")
library(labeling, lib.loc = "E:/RPackage")

dataPath <- getwd()

#加载数据
vehicles <- read.csv(unz("E:/GitHub/R-Project/data/vehicles/vehicles.csv.zip", "vehicles.csv"), stringsAsFactors = F)

#显示头几行数据或尾部几行数据
#head(vehicles)
#tail(vehicles)

#通过labels命令给数据集vehicles.csv文件夹的变量贴上标签，labels是一个函数，数据集的变量名在varlabels.txt中，以-分隔
#labels <- read.table("E:/GitHub/R-Project/data/vehicles/varlabels.txt", header = FALSE)
labels <- do.call(rbind, strsplit(readLines("E:/GitHub/R-Project/data/vehicles/varlabels.txt"), "-"))

#head(labels)

#x <- readLines("E:/GitHub/R-Project/data/vehicles/varlabels.txt")

#数据行数
nrow(vehicles)
#数据列数
ncol(vehicles)
#查看数据列的含义
#这些变更名的含义可以在http://www.fueleconomy.gov/feg/ws/index.shtml#vehicle中详细查看
names(vehicles)

#查看数据中有多少年的数据
length((unique(vehicles[,"year"])))

#查看数据集中的起始年份和终止年份
first_year <- min(vehicles[, "year"])
last_year <- max(vehicles[, "year"])


#查看燃料类型
table(vehicles$fuelType1)

#探索汽车使用的传动方式，缺失值使用NA表示
vehicles$trany[vehicles$trany == ""] <- NA


#trany是一系列文本，仅关注车辆的传动是手动还是自动，所以使用substr函数提取trany会前4个字符生成新的变量trany2
vehicles$trany2 <- ifelse(substr(vehicles$trany, 1, 4) == "Auto", "Auto", "Manual")

#最后，将这个新变量变成因子，使用table函数看不同类型传动方式记录各有多少
vehicles$trany <- as.factor(vehicles$trany)
table(vehicles$trany)

#with说明默认使用vehicles数据集，不用再$符号使用数据
with(vehicles, table(sCharger, year))


#使用plyr和ggplot2探索数据集
#首先看平均MPG是否随着时间有一个趋势上的变化，使用plyr的ddply函数操作vehicles数据集
#按年份整合，对每个组计算highway、city和combine的燃油效率，该结果给一个新的数据框mpgByYr
mpgByYr <- ddply(vehicles, ~year, summarise, avgMPG = mean(comb08), avgHghy = mean(highway08), avgCity = mean(city08))
#对新数据框更好的了解，使用ggplot函数，用散点图绘制avgMPG和year之间的关系。
#标明坐标轴的命名、图的标题，一级加上一个平滑的条件均值，geom_smooth()在图片中增加一个阴影的区域
ggplot(mpgByYr, aes(year, avgMPG)) + geom_point() + geom_smooth() + xlab("Year") + ylab("Average MPG") + ggtitle("All cars")



#非燃油汽车对数据有影响，所以构造新的数据集
gasCars <- subset(vehicles, fuelType1 %in% c("Regular Gasoline", "Premium Gasoline", "Midgrade Gasoline") & fuelType2 == "" & atvType != "Hybrid")
mpgByYr_Gas <- ddply(gasCars, ~year, summarise, avgMPG = mean(comb08))
ggplot(mpgByYr_Gas, aes(year, avgMPG)) + geom_point() + geom_smooth() + xlab("Year") + ylab("Average MPG") + ggtitle("Gasoline cars")


#是否近年来大马力的车产量降低了，如果是这样，可以解释这种增长，首先我们要明确是否大功率的汽车燃油效率更低
#注意变量disp1，表示引擎的排量，单位为升
typeof(gasCars$displ)
#gasCars$displ <- as.numeric(gasCars$displ)
#从散点图中看到引擎排量和燃油效率变量之间确实是负相关，小的车燃油效率会更高
ggplot(gasCars, aes(displ, comb08)) + geom_point() + geom_smooth()


#6、查看是否近几年生产了更多的小车，这样就可以解释燃油效率最近有大幅的提升
avgCarSize <- ddply(gasCars, ~year, summarise, avgDisp1 = mean(gasCars$disp1))
ggplot(avgCarSize, aes(year, avgDisp1)) + geom_point() + geom_smooth() + xlab("Year") + ylab("Average engine displacement(1)")



