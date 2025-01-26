-- Schema Definition
CREATE TABLE `job_seekers` (
  `seeker_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`seeker_id`),
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE `employers` (
  `employer_id` int(11) NOT NULL AUTO_INCREMENT,
  `company_name` varchar(100) NOT NULL,
  `email` varchar(50) NOT NULL,
  PRIMARY KEY (`employer_id`),
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE `job_postings` (
  `posting_id` int(11) NOT NULL AUTO_INCREMENT,
  `employer_id` int(11) NOT NULL,
  `title` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `required_skills` text,
  PRIMARY KEY (`posting_id`),
  FOREIGN KEY (`employer_id`) REFERENCES `employers`(`employer_id`)
);

CREATE TABLE `users` (
  `user_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `user_type` enum('job_seeker','employer') NOT NULL,
  PRIMARY KEY (`user_id`),
  UNIQUE KEY `email` (`email`)
);

CREATE TABLE `logins` (
  `login_id` int(11) NOT NULL AUTO_INCREMENT,
  `user_id` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(100) NOT NULL,
  `user_type` enum('job_seeker','employer') NOT NULL,
  PRIMARY KEY (`login_id`),
  UNIQUE KEY `email` (`email`),
  FOREIGN KEY (`user_id`) REFERENCES `users`(`user_id`)
);

-- CRUD Queries
-- Job Seekers
-- Create Job Seeker
INSERT INTO job_seekers (name, email) VALUES ('John Doe', 'john@example.com');

-- Read Job Seeker
SELECT * FROM job_seekers;

-- Employers
-- Create Employer
INSERT INTO employers (company_name, email) VALUES ('ABC Company', 'info@abc.com');

-- Read Employers
SELECT * FROM employers;

-- Job Postings
-- Create Job Posting
INSERT INTO job_postings (employer_id, title, description, required_skills) VALUES (1, 'Software Engineer', 'Looking for experienced software engineers.', 'Java, Python, SQL');

-- Read Job Postings
SELECT * FROM job_postings;

-- User Signup
-- Job Seeker Signup
INSERT INTO users (name, email, user_type) VALUES ('John Doe', 'john@example.com', 'job_seeker');
INSERT INTO logins (user_id, email, password, user_type) VALUES (LAST_INSERT_ID(), 'john@example.com', 'password123', 'job_seeker');

-- Employer Signup
INSERT INTO users (name, email, user_type) VALUES ('ABC Company', 'info@abc.com', 'employer');
INSERT INTO logins (user_id, email, password, user_type) VALUES (LAST_INSERT_ID(), 'info@abc.com', 'abcpassword', 'employer');

-- Login Queries
-- Job Seeker Login
SELECT * FROM logins WHERE email = 'john@example.com' AND password = 'password123' AND user_type = 'job_seeker';

-- Employer Login
SELECT * FROM logins WHERE email = 'info@abc.com' AND password = 'abcpassword' AND user_type = 'employer';
