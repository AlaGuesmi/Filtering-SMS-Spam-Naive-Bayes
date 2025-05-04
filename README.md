# Filtering-SMS-Spam-Naive-Bayes

This project implements a **spam detection model** for SMS messages using the **Naive Bayes** algorithm in **R**. As mobile phone usage continues to rise, SMS spam has become a growing concern due to its direct cost to users. This model aims to automatically classify messages as either "ham" (legitimate) or "spam", offering a basic yet effective solution to filter unwanted SMS content.

**Methodology**

- Text preprocessing using the tm and quanteda packages (lowercasing, stopword removal, punctuation cleaning, stemming).

- Conversion of text data into a Document-Term Matrix (DTM).

- Naive Bayes classifier implementation using the e1071 package.

- Model evaluation using confusion matrix and accuracy metrics.

- Wordcloud visualization of spam vs. ham messages.

**Dataset**

The project uses the SMSSpamCollection dataset, a labeled collection of **5,574 SMS messages** tagged as either *"spam"* or *"ham"*.

**Goal**

To explore the effectiveness of a Naive Bayes classifier in dealing with short, informal text messages and to highlight the challenges posed by SMS-specific language and formatting.

**Tools & Libraries**

tm, quanteda, SnowballC, wordcloud

e1071 (Naive Bayes implementation)

caret, gmodels (model evaluation)

**Usage**

- Preprocess and clean the SMS data.

- Split the data into training and testing sets.

- Train a Naive Bayes model.

- Evaluate the model's performance.

- Visualize the most frequent words in spam and ham messages.

**Reference**

*This project is based on the SMS spam filtering example from "Machine Learning with R" by Brett Lantz (2015) and adapted from tutorials on Rpubs.*

