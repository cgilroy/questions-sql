DROP TABLE IF EXISTS replies;
DROP TABLE IF EXISTS question_follows;
DROP TABLE IF EXISTS questions;
DROP TABLE IF EXISTS users;
PRAGMA foreign_keys = ON;

CREATE TABLE users (
    id INTEGER PRIMARY KEY,
    fname TEXT NOT NULL,
    lname TEXT NOT NULL
);

INSERT INTO
    users (fname,lname)
VALUES
    ("Connor","McDavid"), ("Leon", "Draisaitl"), ("Johnny", "Toews");

CREATE TABLE questions (
    id INTEGER PRIMARY KEY,
    title TEXT NOT NULL,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    questions (title,body,user_id)
SELECT
    "Playoffs Issue", "Why are we letting so many teams in the playoffs?", 1
FROM
    users
WHERE
    users.fname = "Connor" AND users.lname = "McDavid";

CREATE TABLE question_follows (
  id INTEGER PRIMARY KEY,
  user_id INTEGER NOT NULL,
  question_id INTEGER NOT NULL,

  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (question_id) REFERENCES questions(id)
);

INSERT INTO
    question_follows(user_id, question_id)
VALUES
    (
        (SELECT id FROM users WHERE fname="Connor" and lname="McDavid"),
        (SELECT id FROM questions WHERE title = "Playoffs Issue")
    ),
    (
        (SELECT id FROM users WHERE fname="Leon" and lname="Draisaitl"),
        (SELECT id FROM questions WHERE title = "Playoffs Issue")
    );

CREATE TABLE replies (
    id INTEGER PRIMARY KEY,
    question_id INTEGER NOT NULL,
    parent_id INTEGER,
    body TEXT NOT NULL,
    user_id INTEGER NOT NULL,

    FOREIGN KEY (question_id) REFERENCES questions(id),
    FOREIGN KEY (parent_id) REFERENCES replies(id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);

INSERT INTO
    replies (question_id, parent_id, body, user_id)
VALUES
    (
        (SELECT id FROM questions WHERE title = "Playoffs Issue"),
        NULL,
        "Lol oil are winning the cup",
        (SELECT id FROM users WHERE fname="Leon" AND lname = "Draisaitl")
    );

INSERT INTO
    replies (question_id, parent_id, body, user_id)
VALUES
    (
        (SELECT id FROM questions WHERE title = "Playoffs Issue"),
        (SELECT id FROM replies WHERE body = "Lol oil are winning the cup"),
        "Ya right pal",
        (SELECT id FROM users WHERE fname="Johnny" AND lname = "Toews")
    );