class SpamFilter:
    def __init__(self):
        self.spam_words = ["buy", "sell", "advertise", "free"]
        self.emails = []

    def add_email(self, email):
        self.emails.append(email)

    def filter_spam(self):
        filtered_emails = []
        for email in self.emails:
            is_spam = False
            for word in self.spam_words:
                if word in email:
                    is_spam = True
                    break
            if not is_spam:
                filtered_emails.append(email)
        return filtered_emails

    def train_model(self, emails):
        spam_count = {}
        for email in emails:
            for word in email.split():
                if word not in spam_count:
                    spam_count[word] = 1
                else:
                    spam_count[word] += 1
        sorted_spam_count = sorted(spam_count.items(), key=lambda x: x[1], reverse=True)
        return sorted_spam_count

    def update_spam_words(self, spam_words):
        self.spam_words.extend(spam_words)


class Email:
    def __init__(self, subject, body):
        self.subject = subject
        self.body = body

    def __str__(self):
        return f"Subject: {self.subject}\nBody: {self.body}"

class User:
    def __init__(self, name, email_address):
        self.name = name
        self.email_address = email_address

    def send_email(self, email):
        print(f"Sending email to {self.email_address}: {email}")

    def receive_email(self, email):
        print(f"Receiving email from {self.email_address}: {email}")


spam_filter = SpamFilter()
email1 = Email("Hello", "This is a test email")
email2 = Email("Buy now", "This is a spam email")
email3 = Email("Sell now", "This is a spam email")

user1 = User("John Doe", "john@example.com")
user2 = User("Jane Doe", "jane@example.com")

spam_filter.add_email(str(email1))
spam_filter.add_email(str(email2))
spam_filter.add_email(str(email3))

filtered_emails = spam_filter.filter_spam()
print("Filtered Emails:")
for email in filtered_emails:
    print(email)

spam_words = ["discount", "limited time"]
spam_filter.update_spam_words(spam_words)

trained_model = spam_filter.train_model([str(email1), str(email2), str(email3)])
print("Trained Model:")
for word, count in trained_model:
    print(f"{word}: {count}")

user1.send_email(str(email1))
user2.receive_email(str(email2))