#http://www.kaggle.com/c/titanic-gettingStarted/data下载源数据train.csv

#读取数据并将空数据转为""
train.data = read.csv("E:/javaTest/R/train.csv", na.strings = c("NA", ""))

#显示数据，
str(train.data)

#将int数值类型转换为factor类别类型，使用factor转换函数
train.data$Survived = factor(train.data$Survived)
train.data$Pclass = factor(train.data$Pclass)

str(train.data)

#is.na函数用于检查当前属性值是否包含NA值并标记
is.na(train.data$Age)
#计算年龄字段缺失值的数量
train.age.sum = sum(is.na(train.data$Age) == TRUE)
#计算年龄字段缺失值占比
train.age.percent = train.age.sum / length(train.data$Age)

sapply(train.data, function(df){
  sum(is.na(df) == TRUE) / length(df)
})

require(Amelia)

library("Amelia")

missmap(train.data, main="Missing Map")



