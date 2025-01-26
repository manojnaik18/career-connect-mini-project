from flask import Flask, render_template, request, session, redirect, url_for, flash
from flask_sqlalchemy import SQLAlchemy
from flask_login import UserMixin, login_user, logout_user, login_required, LoginManager, current_user
from werkzeug.security import generate_password_hash, check_password_hash

app = Flask(__name__)
app.secret_key = 'careerconnectprojects'

# SQLAlchemy configuration
app.config['SQLALCHEMY_DATABASE_URI'] = 'mysql://root:@localhost/ccdbms'
db = SQLAlchemy(app)

# Login Manager initialization
login_manager = LoginManager(app)
login_manager.login_view = 'login'

# Define database models
class User(UserMixin, db.Model):
    id = db.Column(db.Integer, primary_key=True)
    username = db.Column(db.String(50))
    email = db.Column(db.String(50), unique=True)
    password = db.Column(db.String(100))
    user_type = db.Column(db.String(20))  # 'job_seeker' or 'employer'

class JobPosting(db.Model):
    id = db.Column(db.Integer, primary_key=True)
    title = db.Column(db.String(100))
    description = db.Column(db.Text)
    skills_required = db.Column(db.Text)
    employer_id = db.Column(db.Integer, db.ForeignKey('user.id'))
    employer = db.relationship('User', backref='job_postings')

# Define user loader function
@login_manager.user_loader
def load_user(user_id):
    return User.query.get(int(user_id))

# Define routes and views
@app.route('/')
def index():
    return render_template('index.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']
        user = User.query.filter_by(email=email).first()
        if user and check_password_hash(user.password, password):
            login_user(user)
            flash('Logged in successfully.', 'success')
            if user.user_type == 'employer':
                return redirect(url_for('employer'))
            elif user.user_type == 'job_seeker':
                return redirect(url_for('j-s-dashboard'))
        else:
            flash('Invalid email or password.', 'error')
    return render_template('login.html')

@app.route('/signup', methods=['GET', 'POST'])
def signup():
    if request.method == 'POST':
        username = request.form['username']
        email = request.form['email']
        password = request.form['password']
        user_type = request.form['user_type']
        hashed_password = generate_password_hash(password)
        new_user = User(username=username, email=email, password=hashed_password, user_type=user_type)
        db.session.add(new_user)
        db.session.commit()
        flash('Account created successfully. Please login.', 'success')
        return redirect(url_for('login'))
    return render_template('signup.html')

@app.route('/j-s-dashboard')
@login_required
def job_seeker_dashboard():
    job_postings = JobPosting.query.all()
    return render_template('j-s-dashboard.html', job_postings=job_postings)

@app.route('/employer1')
@login_required
def employer_dashboard():
    return render_template('employer1.html')

@app.route('/logout')
@login_required
def logout():
    logout_user()
    flash('Logged out successfully.', 'success')
    return redirect(url_for('index'))

if __name__ == '__main__':
    app.run(debug=True, host='127.0.0.1', port=8080)
