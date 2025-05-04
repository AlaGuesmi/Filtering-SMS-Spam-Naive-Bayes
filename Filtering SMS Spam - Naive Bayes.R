# 1. Libraries

#install.packages("quanteda")# Quantitative Analysis of Textual Data.
install.packages("quanteda")

#Libraries
library(quanteda)

# install.packages("tm")
install.packages("tm")
library(tm) #text mining package from R community, tm_map(), content_transformer()
# install.packages("SnowballC")
install.packages("SnowballC")
library(SnowballC) #used for stemming, wordStem(), stemDocument()
# install.packages("wordcloud")
install.packages("wordcloud")
library(wordcloud) #wordcloud generator

# install.packages("e1071")
install.packages("e1071")
library(e1071) #Naive Bayes

# install.packages(gmodels)
install.packages("gmodels")
library(gmodels) #CrossTable()

# install.packages("caret")
install.packages("caret")
library(caret) #ConfusionMatrix()

# 2. Import Data

sms_raw <- read.table("C:\\Users\\Dell\\Downloads\\SMSSpamCollection.txt", 
                      header = FALSE, sep = "\t", quote = "", stringsAsFactors = FALSE)
colnames(sms_raw)=c("type","text")
sms_raw$type <- factor(sms_raw$type)
str(sms_raw$type)
table(sms_raw$type)

# 3. Mining the SMS with the "tm" package

library(tm)
sms_corpus <- VCorpus(VectorSource(sms_raw$text))
print(sms_corpus)

inspect(sms_corpus[1:4])

as.character(sms_corpus[[3]])

sms_corpus_clean <- tm_map(sms_corpus, FUN = content_transformer(tolower))

as.character(sms_corpus[[3]])

as.character((sms_corpus_clean[[3]]))

sms_corpus_clean <- tm_map(sms_corpus_clean, removeNumbers)

sms_corpus_clean <- tm_map(sms_corpus_clean, removeWords, stopwords())

sms_corpus_clean <- tm_map(sms_corpus_clean, removePunctuation)
as.character((sms_corpus_clean[[3]]))

library(SnowballC)
sms_corpus_clean <- tm_map(sms_corpus_clean, stemDocument)

sms_corpus_clean <- tm_map(sms_corpus_clean, stripWhitespace)
as.character(sms_corpus_clean[[3]])

sms_dtm <- DocumentTermMatrix(sms_corpus_clean)

# 4.Data Preparation
#Split our data into training and testing sets, so that after Naive Bayes spam filter algorithm is built it can be applied to unseen data. Divide our data set into 75% training and 25% testing.

.75 * 5574

.25 * 5574

#Because the dataset is random, there’s no need to randomize the objects order in the data. The first 4180 messages can be used for the training set.

sms_dtm_train <- sms_dtm[1:4180, ]
sms_dtm_test <- sms_dtm[4181:5559, ]

#Save vectors labeling rows in the training and testing vectors
sms_train_labels <- sms_raw[1:4180, ]$type
sms_test_labels <- sms_raw[4181:5559,]$type

prop.table(table(sms_train_labels))

prop.table(table(sms_test_labels))

# 5. Visualization

#Create a wordcloud of the frequency of the words in the dataset using the package “wordcloud”.
library(wordcloud)
wordcloud(sms_corpus_clean, max.words = 50, random.order = FALSE)

#Compare wordclouds between spam and ham.

spam <- subset(sms_raw, type == "spam")
ham <- subset(sms_raw, type == "ham")
wordcloud(spam$text, max.words = 30)

wordcloud(ham$text, max.words = 30)

# 6. Preparation for Naive Bayes
#Remove words from the matrix that appear less than 5 times.
library(quanteda)
sms_freq_words <- findFreqTerms(sms_dtm_train, 5)
str(sms_freq_words)

#Limit our Document Term Matrix to only include words in the sms_freq_vector. We want all the rows, but we want to limit the column to these words in the frequency vector.
sms_dtm_freq_train <- sms_dtm_train[ , sms_freq_words]
sms_dtm_freq_test <- sms_dtm_test[ , sms_freq_words]

convert_counts <- function(x) {
  x <- ifelse(x > 0, "Yes", "No")
}

sms_train <- apply(sms_dtm_freq_train, MARGIN = 2, convert_counts)

sms_test <- apply(sms_dtm_freq_test, MARGIN = 2, convert_counts)

# 7. Train Model on the Data

library(e1071)

sms_classifier <- naiveBayes(sms_train, sms_train_labels)

# 8. Predict and Evaluate the Model
sms_test_pred <- predict(sms_classifier, sms_test, laplace=T)

library(gmodels)
CrossTable(sms_test_pred, sms_test_labels, prop.chisq = FALSE, prop.t = FALSE, dnn = c('predicted', 'actual'))

library(caret)
confusionMatrix(sms_test_pred, sms_test_labels)
