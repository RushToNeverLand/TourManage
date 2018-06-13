# coding=utf-8

from flask import Flask,render_template,request
from dateutil import rrule
import pymssql
import datetime

ID = ''

app = Flask(__name__)
@app.route('/')
def index():
    return render_template('manage_sign.html')

@app.route('/manage_sign')
def sign():
    id=request.args.get('id', '')
    pwd=request.args.get('pwd', '')
    if id == '' and pwd == '':
        return render_template('manage_sign.html',var=u'登陆请输入用户名和密码')
    elif id == '' or pwd == '':
        return render_template('manage_sign.html', var=u'用户名或密码不可为空')
    else:
        conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
        cursor = conn.cursor()
        cursor.execute('select * from manager where id = %s and pwd = %s',(id,pwd))
        rows=cursor.fetchall()
        if len(rows) > 0:
            global ID
            ID = id
            return render_template('manage_home.html')
        else:
            return render_template('manage_sign.html', var=u'用户名或密码错误')


@app.route('/manage_jingdian')
def manage_jingdian():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    d = request.args.get('d', '')
    e = request.args.get('e', '')
    f = request.args.get('f', '')
    a2 = request.args.get('a2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    if a2 == '':
        if a != '' and b != '' and c != '' and d != '' and e != '' and f != '':
            cursor.execute("select * from 景点 where 景点.景点编号 = %s",(a))
            rows = cursor.fetchall()
            if len(rows) == 0:
                cursor.execute('insert into 景点 values (%s,%s,%s,%s,%s,%s)',(a,b,c,d,e,f))
            else:
                cursor.execute('update 景点 set 景点名称=%s,所在地=%s,级别=%s,电话=%s,票价=%s where 景点编号=%s',(b,c,d,e,f,a))
            conn.commit()

        if a == '' or b == '' or c == '' or d == '' or e == '' or f == '':
            return render_template('manage_jingdian.html',var=u'该景点没有出现在表中')
        else:
            return render_template('manage_thx.html')

    else:
        cursor.execute('select * from 景点安排 where 景点编号 = %s',a2)
        rows=cursor.fetchall()
        if len(rows) != 0:
            return render_template('manage_jingdian.html',var=u'该景点在景点安排关系中出现，无法删除')

        cursor.execute('select * from 景点 where 景点编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_jingdian.html',var=u'该景点没有出现在表中')

        cursor.execute('delete from 景点 where 景点编号 = %s',a2)
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_binguan')
def manage_binguan():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    d = request.args.get('d', '')
    e = request.args.get('e', '')
    a2 = request.args.get('a2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    if a2 == '':
        if a != '' and b != '' and c != '' and d != '' and e != '':
            cursor.execute("select * from 宾馆 where 宾馆编号 = %s",(a))
            rows = cursor.fetchall()
            if (c=='1' and int(d)<int('200')) or (c=='2' and int(d)<int('300')) or (c=='3' and int(d)<int('500')):
                return render_template('manage_binguan.html',var=u'星级不符合标准')
            if len(rows) == 0:
                cursor.execute('insert into 宾馆 values (%s,%s,%s,%s,%s)',(a,b,c,d,e))
            else:
                cursor.execute('update 宾馆 set 宾馆名称=%s,星级=%s,标准房价=%s,电话=%s where 宾馆编号=%s',(b,c,d,e,a))
            conn.commit()

        if a == '' or b == '' or c == '' or d == '' or e == '':
            return render_template('manage_binguan.html',var=u'必填信息不可不填')
        else:
            return render_template('manage_thx.html')

    else:
        cursor.execute('select * from 宾馆安排 where 宾馆编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_binguan.html',var=u'该宾馆在宾馆安排中出现，无法删除')

        cursor.execute('select * from 宾馆 where 宾馆编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_binguan.html',var=u'该宾馆没有出现在表中')

        cursor.execute('delete from 宾馆 where 宾馆编号 = %s',(a2))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_xianlu')
def manage_xianlu():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    a2 = request.args.get('a2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    if a2 == '':
        if a != '' and b != '':
            cursor.execute("select * from 线路 where 线路号 = %s",(a))
            rows = cursor.fetchall()
            if len(rows) == 0:
                cursor.execute('insert into 线路 values (%s,%s,%s)',(a,b,c))
            else:
                cursor.execute('update 线路 set 线路名称=%s,说明=%s where 线路号=%s',(b,c,a))
            conn.commit()

        if a == '' or b == '':
            return render_template('manage_xianlu.html',var=u'必填信息不可不填')
        else:
            return render_template('manage_thx.html')

    else:
        cursor.execute('select * from 线路安排 where 线路编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_xianlu.html',var=u'线路在线路安排关系集中出现，无法删除')

        cursor.execute('select * from 宾馆安排 where 线路编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_xianlu.html',var=u'线路在宾馆安排关系集中出现，无法删除')

        cursor.execute('select * from 景点安排 where 线路编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_xianlu.html',var=u'线路在景点安排关系集中出现，无法删除')

        cursor.execute('select * from 线路 where 线路号 = %s',(a2))
        rows = cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_xianlu.html',var=u'没有此线路的信息')

        cursor.execute('delete from 线路 where 线路号 = %s', (a2))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_lvyoutuan')
def manage_lvyoutuan():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    d = request.args.get('d', '')
    e = request.args.get('e', '')
    f = request.args.get('f', '')
    g = request.args.get('g', '')
    a2 = request.args.get('a2','')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    if a2 == '':
        if a != '' and b != '' and c != '' and d != '' and e != '' and f != '' and g != '':
            cursor.execute("select * from 旅游团 where 团号 = %s",(a))
            rows = cursor.fetchall()
            if len(rows) == 0:
                cursor.execute('insert into 旅游团 values (%s,%s,%s,%s,%s,%s,%s)',(a,b,c,d,e,f,g))
            else:
                cursor.execute('update 旅游团 set 团名=%s,人数限制=%s,报价=%s,组团日期=%s,开始日期=%s,结束日期=%s where 团号=%s',(b,c,d,e,f,g,a))
            conn.commit()

        if a == '' or b == '' or c == '' or d == '' or e == '' or f=='' or g=='':
            return render_template('manage_lvyoutuan.html',var=u'必填信息不可不填')
        else:
            return render_template('manage_thx.html')

    else:
        cursor.execute('select * from 线路安排 where 旅游团号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_lvyoutuan.html',var = u'此旅游团在线路安排关系表中出现，无法删除')

        cursor .execute('select * from 参团游客 where 旅游团号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_lvyoutuan.html',var = u'此旅游团在参团游客关系表中出现，无法删除')

        cursor.execute('select * from 参团群体 where 旅游团编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_lvyoutuan.html',var = u'此旅游团在参团群体关系表中出现，无法删除')

        cursor.execute('select * from 旅游团 where 团号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_lvyoutuan',var =u'此旅游团没有出现在表中')

        cursor.execute('delete from 旅游团 where 团号 = %s',(a2))
        conn.commit()
        return render_template('manage_thx.html')


@app.route('/manage_daoyou')
def manage_daoyou():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    d = request.args.get('d', '')
    e = request.args.get('e', '')
    f = request.args.get('f', '')
    a2 = request.args.get('a2','')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a2 == '':
        if a != '' and b != '' and c != '' and d != '' and e != '' and f != '':
            cursor.execute("select * from 导游 where 导游编号 = %s",(a))
            rows = cursor.fetchall()

            birth=d
            now = datetime.datetime.now()
            format = "%Y-%m-%d"
            birth = datetime.datetime.strptime(birth, format)
            years = rrule.rrule(rrule.YEARLY, dtstart=birth, until=now).count()

            if (e=='1' and years<int('3')) or (e=='2' and years<int('5')) or (e=='3' and years<int('10')) or (e=='4' and years<int('15')):
                return render_template('manage_daoyou.html',var=u'工龄不符合标准')
            if len(rows) == 0:
                cursor.execute('insert into 导游 values (%s,%s,%s,%s,%s,%s)',(a,b,c,d,e,f))
            else:
                cursor.execute('update 导游 set 导游姓名=%s,性别=%s,入职日期=%s,级别=%s,积分=%s where 导游编号=%s',(b,c,d,e,f,a))
            conn.commit()

        if a == '' or b == '' or c == '' or d == '' or e == '' or f == '':
            return render_template('manage_daoyou.html',var=u'必填信息不可不填')
        else:
            return render_template('manage_thx.html')

    else:
        cursor.execute('select * from 带队记录 where 导游编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_daoyou.html',var=u'此导游在带队记录中出现，无法删除')

        cursor.execute('select * from 已处理记录 where 导游编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_daoyou.html',var=u'此导游在已处理记录关系表中出现，无法删除')

        cursor.execute('select * from 导游 where 导游编号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_daoyou.html',var = u'此导游没有在表中出现过')

        cursor.execute('delete from 导游 where 导游编号 = %s',(a2))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_youke')
def manage_youke():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    d = request.args.get('d', '')
    e = request.args.get('e', '')
    f = request.args.get('f', '')
    g = request.args.get('g', '')
    h = request.args.get('h', '')
    a2 = request.args.get('a2','')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()
    if a2 == '':
        if a != '' and b != '' and c != '' and d != '' and e != '' and h != '':
            birth = a[6:14]
            now = datetime.datetime.now()
            format = "%Y-%m-%d"
            birth = datetime.datetime.strptime(birth, format)
            years = rrule.rrule(rrule.YEARLY, dtstart=birth, until=now).count()

            if (years > 60 or years <18 ) and (f == '' or g == ''):
                return render_template('manage_youke.html',var=u'年龄大于60岁或者年龄小于18岁的必须要填写紧急联系人和紧急联系号码')
            cursor.execute("select * from 游客 where 身份证号 = %s",(a))
            rows = cursor.fetchall()
            if len(rows) == 0:
                cursor.execute('insert into 游客 values (%s,%s,%s,%s,%s,%s,%s,%s)',(a,b,c,d,e,f,g,h))
            else:
                cursor.execute('update 游客 set 游客姓名=%s,性别=%s,民族=%s,手机号=%s,紧急联系人=%s,紧急联系号码=%s,密码=%s where 身份证号=%s',(b,c,d,e,f,g,h,a))
            conn.commit()
            return render_template('manage_thx.html')
        else:
            return render_template('manage_youke.html',var=u'必填信息不可不填')
    else:
        cursor.execute('select * from 参团游客 where 游客身份证号 = %s',(a2))
        rows = cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_youke.html',var=u'此游客出现在参团游客关系集中，无法删除')

        cursor.execute('select * from 所属群体 where 游客身份证号 = %s',(a2))
        rows = cursor.fetchall()
        if len(rows) > 0:
            return render_template('manage_youke.html',var=u'此游客出现在所属群体关系集中，无法删除')

        cursor.execute('select * from 游客 where 身份证号 = %s',(a2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_youke.html',var=u'此游客没有出现在表中')

        cursor.execute('delete from 游客 where 身份证号 = %s',(a2))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/add_manager')
def manage():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    c = request.args.get('c', '')
    global ID
    id = ID

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a == '':
        if b == '' or c == '':
            return render_template('add_manager.html',var=u'必填信息不可为空')
        cursor.execute('select * from manager where id = %s',(b))
        rows=cursor.fetchall()
        if len(rows) > 0:
            return render_template('add_manager.html',var=u'此管理员账号已存在，无法新增')
        cursor.execute('insert into manager values(%s,%s)',(b,c))
        conn.commit()
        return render_template('manage_thx.html')
    else:
        cursor.execute('update manager set pwd = %s where id = %s',(a,id))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_xianbin')
def xianbin():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    a2 = request.args.get('a2', '')
    b2 = request.args.get('b2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a2 == '':
        if a == '' or b == '':
            return render_template('manage_xianbin.html', var=u'必填信息不可不填')
        cursor.execute('select * from 宾馆安排 where 宾馆编号 = %s and 线路编号 = %s',(a,b))
        rows=cursor.fetchall()
        if len(rows) == 0:
            cursor.execute('insert into 宾馆安排 values(%s,%s)',(a,b))
            conn.commit()
            return render_template('manage_thx.html')
        else:
            return render_template('manage_xianbin.html',var=u'该记录已经存在，无法加入')

    else:
        if a2 == '' or b2 == '':
            return render_template('manage_xianbin.html',var=u'必填信息不可不填')
        cursor.execute('select * from 宾馆安排 where 宾馆编号 = %s and 线路编号 = %s', (a2, b2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_xianbin.html',var=u'该记录不存在数据库中，无法删除')
        cursor.execute('delete from 宾馆安排 where 宾馆编号 = %s and 线路编号 = %s',(a2,b2))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_xianjing')
def xianjing():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    a2 = request.args.get('a2', '')
    b2 = request.args.get('b2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a2 == '':
        if a == '' or b == '':
            return render_template('manage_xianjing.html', var=u'必填信息不可不填')
        cursor.execute('select * from 景点安排 where 景点编号 = %s and 线路编号 = %s',(a,b))
        rows=cursor.fetchall()
        if len(rows) == 0:
            cursor.execute('insert into 景点安排 values(%s,%s)',(a,b))
            conn.commit()
            return render_template('manage_thx.html')
        else:
            return render_template('manage_xianjing.html',var=u'该记录已经存在，无法加入')

    else:
        if a2 == '' or b2 == '':
            return render_template('manage_xianjing.html',var=u'必填信息不可不填')
        cursor.execute('select * from 景点安排 where 景点编号 = %s and 线路编号 = %s', (a2, b2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_xianjing.html',var=u'该记录不存在数据库中，无法删除')
        cursor.execute('delete from 景点安排 where 景点编号 = %s and 线路编号 = %s',(a2,b2))
        conn.commit()
        return render_template('manage_thx.html')


@app.route('/manage_xianlv')
def xianlv():
    a = request.args.get('a', '')
    b = request.args.get('b', '')
    a2 = request.args.get('a2', '')
    b2 = request.args.get('b2', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a2 == '':
        if a == '' or b == '':
            return render_template('manage_xianlv.html', var=u'必填信息不可不填')
        cursor.execute('select * from 线路安排 where 旅游团号 = %s and 线路编号 = %s',(a,b))
        rows=cursor.fetchall()
        if len(rows) == 0:
            cursor.execute('insert into 线路安排 values(%s,%s)',(a,b))
            conn.commit()
            return render_template('manage_thx.html')
        else:
            return render_template('manage_xianlv.html',var=u'该记录已经存在，无法加入')

    else:
        if a2 == '' or b2 == '':
            return render_template('manage_xianlv.html',var=u'必填信息不可不填')
        cursor.execute('select * from 线路安排 where 旅游团号 = %s and 线路编号 = %s', (a2, b2))
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_xianlv.html',var=u'该记录不存在数据库中，无法删除')
        cursor.execute('delete from 线路安排 where 旅游团号 = %s and 线路编号 = %s',(a2,b2))
        conn.commit()
        return render_template('manage_thx.html')


@app.route('/manage_join')
def join():
    a = request.args.get('a', '')
    b = request.args.get('b', '')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a == '' or b == '':
        cursor.execute('select * from orde')
        rows = cursor.fetchall()
        var = []
        for row in rows:
            temp = []
            for i in row:
                temp.append({'caption': i})
            var.append({'column': temp})

        rows = (u'旅游团号', u'游客身份证号', u'缴纳费用')
        var2 = []
        for row in rows:
            var2.append({'value': row})

        return render_template('manage_join.html',seq=var2,navigation=var)
    else:
        cursor.execute('select * from orde')
        rows=cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_join.html',var=u'没有需要处理的记录')

        cursor.execute('exec orde_加入游客记录 @P1= %s,@P2= %s',(a,b))
        conn.commit()
        return render_template('manage_thx.html')

@app.route('/manage_grade')
def grade():
    a = request.args.get('a','')
    b = request.args.get('b','')

    conn = pymssql.connect(host="127.0.0.1", user="sa", password="sql123", database="Trip")
    cursor = conn.cursor()

    if a != '':
        cursor.execute('select * from 带队记录 where 导游编号 = %s',(a))
        rows = cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_grade.html',var=u'此导游没有需要结算的记录或已经结算完毕')
        cursor.execute('exec 带队记录_更新导游业绩 @P1 = %s',(a))
        conn.commit()
        return render_template('manage_thx.html')
    elif b != '':
        cursor.execute('select * from 带队记录')
        rows = cursor.fetchall()
        if len(rows) == 0:
            return render_template('manage_grade.html',var=u'没有需要处理的带队记录')
        else:
            cursor.execute('exec 带队记录_更新业绩')
            conn.commit()
            return render_template('manage_thx.html')
    else:
        return render_template('manage_grade.html')

@app.route('/manage_thx')
def thx():
    return render_template('manage_thx.html')

if __name__ == '__main__':
    app.run()