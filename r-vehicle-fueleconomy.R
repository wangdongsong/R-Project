#练习：汽车数据的可视化分析

#数据源：http://www.fueleconomy.gov/feg/epadata/vehicles.csv.zip
#数据源说明：http://www.fueleconomy.gov/feg/ws/index.shtml#vehicle

#加载所需要的R包
library(plyr, lib.loc = "E:/RPackage")
library(ggplot2, lib.loc = "E:/RPackage")
library(reshape2, lib.loc = "E:/RPackage")

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

x <- readLines("E:/GitHub/R-Project/data/vehicles/varlabels.txt")
