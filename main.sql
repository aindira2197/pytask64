CREATE TABLE Emails (
    id INT PRIMARY KEY,
    sender VARCHAR(255),
    recipient VARCHAR(255),
    subject VARCHAR(255),
    body TEXT,
    spam_score FLOAT
);

CREATE TABLE Spam_Words (
    id INT PRIMARY KEY,
    word VARCHAR(255)
);

CREATE TABLE Spam_Scores (
    id INT PRIMARY KEY,
    spam_word_id INT,
    score FLOAT,
    FOREIGN KEY (spam_word_id) REFERENCES Spam_Words(id)
);

INSERT INTO Spam_Words (id, word) VALUES
(1, 'free'),
(2, 'buy'),
(3, 'sell'),
(4, 'offer'),
(5, 'discount');

INSERT INTO Spam_Scores (id, spam_word_id, score) VALUES
(1, 1, 0.5),
(2, 2, 0.3),
(3, 3, 0.2),
(4, 4, 0.8),
(5, 5, 0.6);

CREATE FUNCTION calculate_spam_score(email_body TEXT) RETURNS FLOAT
BEGIN
    DECLARE spam_score FLOAT DEFAULT 0;
    DECLARE word VARCHAR(255);
    DECLARE cursor1 CURSOR FOR SELECT word FROM Spam_Words;
    OPEN cursor1;
    read_loop: LOOP
        FETCH cursor1 INTO word;
        IF DONE THEN
            LEAVE read_loop;
        END IF;
        IF LOCATE(word, email_body) > 0 THEN
            SET spam_score = spam_score + (SELECT score FROM Spam_Scores WHERE spam_word_id = (SELECT id FROM Spam_Words WHERE word = word));
        END IF;
    END LOOP;
    CLOSE cursor1;
    RETURN spam_score;
END;

CREATE TRIGGER calculate_spam_score_trigger BEFORE INSERT ON Emails
FOR EACH ROW
SET NEW.spam_score = calculate_spam_score(NEW.body);

INSERT INTO Emails (id, sender, recipient, subject, body) VALUES
(1, 'example@example.com', 'example@example.com', 'Test Email', 'This is a test email with free offer and discount'));

SELECT * FROM Emails WHERE spam_score > 1;