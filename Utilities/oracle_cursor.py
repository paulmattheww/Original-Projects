import cx_Oracle

def oracle_cursor(query):
    """
    Connect to Oracle DB user .setup.conf file, execute provided query,
    return as cursor object
    """
    conf_file_dir = os.path.dirname(os.path.realpath(__file__))
    conf_file = conf_file_dir + os.sep + '.setup.conf'
    (username, password, host, port, sid) = credential_setup(conf_file)
    dsn_tns = cx_Oracle.makedsn(host, port, sid)
    connection = cx_Oracle.connect(username, password, dsn_tns)
    cursor = connection.cursor()
    cursor.execute(query)

    return cursor
