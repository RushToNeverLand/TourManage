# coding=utf-8

from flask import Flask,render_template,request
from dateutil import rrule
import pymssql
import datetime

app = Flask(__name__)
flag = False
ID = ''

@app.route("/")
def index():
    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    ## 热门景点部分
    cursor.execute("select * from 热门景点")
    rows = cursor.fetchall()
    var = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption': i})
        var.append({'column':temp})

    cursor.execute("exec 查询列名 @P1='热门景点'")
    rows =  cursor.fetchall()
    var2 = []
    for row in rows:
        var2.append({'value':row[0]})


    ## 热门线路部分
    cursor.execute("select * from 热门线路")
    rows = cursor.fetchall()
    var3 = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption2': i})
        var3.append({'column2':temp})

    cursor.execute("exec 查询列名 @P1='热门线路'")
    rows =  cursor.fetchall()
    var4 = []
    for row in rows:
        var4.append({'value2':row[0]})


    ## 金牌导游部分
    cursor.execute("select * from 金牌导游")
    rows = cursor.fetchall()
    var5 = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption3': i})
        var5.append({'column3':temp})

    cursor.execute("exec 查询列名 @P1='金牌导游'")
    rows =  cursor.fetchall()
    var6 = []
    for row in rows:
        var6.append({'value3':row[0]})
    return render_template('home.html',seq=var2,navigation=var,seq2=var4,navigation2=var3,seq3=var6,navigation3=var5)

    # if len(rows) == 0:
    #     return render_template('sign.html')
    # else:
    #     # return render_template('form.html')
    #     for row in rows:
    #         print(row)
    # return u"Hello World!"

@app.route('/back')
def back():
    city = request.args.get('city', '')
    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    cursor.execute("exec 景点_搜索所在地 @P1=%s",(city))
    rows = cursor.fetchall()

    cursor.execute("exec 景点_搜索所在地 @P1=%s",(city))
    rows = cursor.fetchall()
    var = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption': i})
        var.append({'column':temp})

    rows = (u'景点名称',u'级别',u'票价')
    var2 = []
    for row in rows:
        var2.append({'value':row})

    cursor.execute("exec 城市_推荐旅游团 @P1=%s",(city))
    rows = cursor.fetchall()
    var3 = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption': i})
        var3.append({'column':temp})

    rows = (u'团名',u'人数限制',u'报价',u'组团日期',u'开始日期',u'结束日期')
    var4 = []
    for row in rows:
        var4.append({'value':row})

    return render_template('back.html',var=city,seq=var2,navigation=var,seq2=var4,navigation2=var3)


@app.route('/back2')
def back2():
    site = request.args.get('site', '')
    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    cursor.execute("exec 景点_关联线路 @P1=%s",(site))
    rows = cursor.fetchall()
    var = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption': i})
        var.append({'column':temp})

    rows = (u'线路名称',u'线路说明')
    var2 = []
    for row in rows:
        var2.append({'value':row})

    cursor.execute("exec 景点_推荐旅游团 @P1=%s",(site))
    rows = cursor.fetchall()
    var3 = []
    for row in rows:
        temp = []
        for i in row:
            temp.append({'caption': i})
        var3.append({'column':temp})

    rows = (u'团名',u'人数限制',u'报价',u'组团日期',u'开始日期',u'结束日期')
    var4 = []
    for row in rows:
        var4.append({'value':row})

    return render_template('back2.html',var=site,seq=var2,navigation=var,seq2=var4,navigation2=var3)


@app.route('/sign')
def sign():
    id=request.args.get('id', '')
    pwd=request.args.get('pwd', '')
    if id == '' and pwd == '':
        return render_template('sign.html',var=u'登陆请输入用户名和密码')
    elif id == '' or pwd == '':
        return render_template('sign.html', var=u'用户名或密码不可为空')
    else:
        conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123",database="Trip")
        cursor = conn.cursor()
        cursor.execute("select * from 游客 where 游客.身份证号 = %s and 游客.密码 = %s",(id,pwd))
        rows = cursor.fetchall()
        if len(rows) == 0:
            # return render_template('sign.html', var=u'用户名或密码错误')
            return render_template('form.html')
        else:
            # request.args['id']
            # request.args['pwd'] = pwd
            global flag
            global ID
            flag = True
            ID = id
            # return render_template('orde.html')
            return '<script language="javascript" type="text/javascript"> window.location.href="/orde"; </script> '

@app.route('/form')
def form():
    id = request.args.get('id', '')
    name = request.args.get('name', '')
    sex = request.args.get('sex', '')
    nation = request.args.get('nation', '')
    telephone = request.args.get('telephone', '')
    emergency = request.args.get('emergency', '')
    emerphone = request.args.get('emerphone', '')
    pwd = request.args.get('pwd', '')
    if sex == '男' or sex == '女':
        if id == '' or pwd == '' or name == '' or sex == '' or nation == '' or telephone == '':
            return render_template('form.html', var=u"星号为必填信息，不可为空")
        else:
            if len(id) != 18:
                return render_template('form.html',var=u'身份证必须为18位')
            birth = id[6:14]
            if int(birth[10:12]) > 12:
                return render_template('form.html', var=u'身份证不规范')
            now=datetime.datetime.now()
            format = "%Y%m%d"
            birth = datetime.datetime.strptime(birth, format)
            years = rrule.rrule(rrule.YEARLY, dtstart=birth, until=now).count()
            if (years < 18 or years > 60) and (emergency == '' or emerphone == ''):
                return render_template('form.html',var=u'年龄小于18岁或者年龄大于60岁的顾客必须填写紧急联系人姓名和电话')
            else:
                conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
                cursor = conn.cursor()
                cursor.execute("insert into 游客 values(%s,%s,%s,%s,%s,%s,%s,%s)",(id,name,sex,nation,telephone,emergency,emerphone,pwd))
                conn.commit()
                global ID
                global flag
                flag = True
                ID = id
                return '<script language="javascript" type="text/javascript"> window.location.href="/orde"; </script> '

    else:
        return render_template('form.html', var=u"性别信息只可填为男或为女")

@app.route('/delete')
def delete():

    return 'delete'

@app.route('/orde')
def orde():
    global flag
    global ID
    id = ID

    a = request.args.get('a','')

    if a == '' or id == '':
        return render_template('orde.html')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    cursor.execute('select * from 游客 where 身份证号 = %s',(id))
    rows1=cursor.fetchall()
    if len(rows1) == 0:
        return render_template('orde.html',var=u'没有查到该用户的信息')

    cursor.execute('select * from 旅游团 where 团号 = %s',(a))
    rows=cursor.fetchall()
    if len(rows) == 0:
        return render_template('orde.html',var=u'没有查到该旅行团的消息，请核实后填写')

    cursor.execute('select 报价 from 旅游团 where 团号 = %s',(a))
    rows=cursor.fetchall()
    mon=float(rows[0][0])

    cursor.execute('select * from orde where 旅游团号 = %s and 游客身份证号 = %s',(a,id))
    rows=cursor.fetchall()
    if len(rows) == 0:
        if len(rows1) >= 3:
            cursor.execute('insert into orde values(%s,%s,%s)',(a,id,mon*0.8))
        else:
            cursor.execute('insert into orde values(%s,%s,%s)',(a,id,mon))
        conn.commit()
    else:
        if len(rows1) >= 3:
            # cursor.execute('insert into orde values(%s,%s,%f)',(id,a,mon*0.8))
            cursor.execute('update orde set 缴纳费用 = %s where 旅游团号 = %s and 游客身份证号 = %s',(mon*0.8,a,id))
        else:
            cursor.execute('update orde set 缴纳费用 = %s where 旅游团号 = %s and 游客身份证号 = %s', (mon,a,id))
        conn.commit()

    return render_template('thx.html')

@app.route('/change')
def change():
    global ID
    id = ID

    pwd=request.args.get('a','')

    print(pwd,id)
    if pwd == '' or id =='':
        return render_template('change.html',var=u'必填信息不可省略')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    cursor.execute('update 游客 set 密码 = %s where 身份证号 = %s',(pwd,id))
    conn.commit()

    return render_template('thx.html')

@app.route('/thx')
def thx():
    return render_template('thx.html')

if __name__ == '__main__':
    app.run()