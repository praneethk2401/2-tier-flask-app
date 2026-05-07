from flask import Flask, render_template, request, redirect, url_for
from flask_mysqldb import MySQL

app = Flask(__name__)

# MySQL config
app.config['MYSQL_HOST'] = 'mysql'
app.config['MYSQL_USER'] = 'root'
app.config['MYSQL_PASSWORD'] = 'root'
app.config['MYSQL_DB'] = 'devops'

mysql = MySQL(app)

@app.route('/')
def index():
    cursor = mysql.connection.cursor()
    cursor.execute('CREATE TABLE IF NOT EXISTS messages (id INT AUTO_INCREMENT PRIMARY KEY, message VARCHAR(255))')
    cursor.execute('SELECT * FROM messages')
    messages = cursor.fetchall()
    cursor.close()
    return render_template('index.html', messages=messages)

@app.route('/add', methods=['POST'])
def add_message():
    message = request.form.get('message')
    if message:
        cursor = mysql.connection.cursor()
        cursor.execute('INSERT INTO messages (message) VALUES (%s)', (message,))
        mysql.connection.commit()
        cursor.close()
    return redirect(url_for('index'))

@app.route('/health')
def health():
    return 'OK', 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=True)