#!/usr/bin/env python
# coding: utf-8

# ## This notebook contains all of the code and comments for the CSCI341 Database Systems Assignment 2

# In[1]:


# importing necessary libraries
from sqlalchemy import create_engine, MetaData, Table, func
from sqlalchemy.orm import sessionmaker
from sqlalchemy.ext.declarative import declarative_base


# In[2]:


# a function to connect to our db and create an engine object so that
# we can work on it afterwards
def get_connection():
    return create_engine(url="mysql://root:12345678@localhost:3306/assignment2")


# In[3]:


if __name__ == '__main__':
    try:
        db_engine = get_connection()
        print("Connection to the localhost for user root created successfully.")
    except Exception as ex:
        print("Connection could not be made due to the following error", ex)


# In[4]:


# checking our new engine
db_engine


# In[5]:


Base = declarative_base()
engine_metadata = MetaData(db_engine)


# In[6]:


# creating a session class instance from the sessionmaker method from SQLAlchemy
Session = sessionmaker(bind=db_engine)


# In[7]:


# starting our session
db_session = Session()


# In[8]:


# Creating and saving metadata for the tables from our MySQL database so that we know that information they containt
# and can perform some operations in the future

disease_type_table_md = Table('DiseaseType', engine_metadata, autoload=True)

country_table_md = Table('Country', engine_metadata, autoload=True)

disease_table_md = Table('Disease', engine_metadata, autoload=True)

discover_table_md = Table('Discover', engine_metadata, autoload=True)

users_table_md =Table('Users', engine_metadata, autoload=True)

public_servant_table_md =Table('PublicServant', engine_metadata, autoload=True)

doctor_table_md=Table('Doctor', engine_metadata, autoload=True)

specialize_table_md = Table('Specialize', engine_metadata, autoload=True)

records_table_md = Table('Record', engine_metadata, autoload=True)


# ### *1. Below is everything related to the 1st query*

# In[9]:


from sqlalchemy import and_


# In[12]:


# Query 1. List the disease code and the description of diseases that are caused by 
# “bacteria” (pathogen) and were discovered before 1990.

# a function to do this:
def query1():
    disease_code = db_session.query(discover_table_md.c.disease_code).filter(discover_table_md.c.first_enc_date <= '1899-12-31').all()
    disease = []
    
    for i in disease_code:
        disease.append(i[0])
    
    answers = db_session.query(disease_table_md.c.disease_code, disease_table_md.c.description).filter(
        and_(disease_table_md.c.pathogen =="bacteria", disease_table_md.c.disease_code.in_(disease))).all()
    
    result = []
    for x in answers:
        result.append([x[0] +" - "+ x[1]])
    
    return print("Here are the needed diseases: {}".format(result))


# In[13]:


query1()


# ### *2. Below is everything related to the 2nd Query*

# In[16]:


# Query 2. List the name, surname and degree of doctors who are not specialized in “infectious diseases”.
def query2():
    first_list = db_session.query(disease_type_table_md.c.id).filter(disease_type_table_md.c.description != 'infectious diseases').all()
    list = []
    for x in first_list:
        list.append([x[0]])
    
    list_docs = db_session.query(specialize_table_md.c.email).filter(specialize_table_md.c.id.in_(list)).all()
    emails_docs = []
    for x in list_docs:
        emails_docs.append([x[0]])
    
    names_docs = db_session.query(users_table_md.c.name, users_table_md.c.surname, doctor_table_md.c.degree).filter(
        and_(users_table_md.c.email.in_(emails_docs),doctor_table_md.c.email.in_(emails_docs))).limit(len(emails_docs)).all()
    
    result=[]
    for doc in names_docs:
        result.append([doc])

    return print("Here are the doctors: {}".format(result))


# In[17]:


query2()


# ### *3. Below is everything related to the 3rd query*

# In[18]:


# Query 3. List the name, surname and degree of doctors who are specialized in more than 2 disease types.

def query3():
    two_and_more = db_session.query(specialize_table_md.c.email).group_by(specialize_table_md.c.email).having(func.count(specialize_table_md.c.email) >= 2).all()
    list = []
    
    for x in two_and_more:
        list.append(x[0])
    
    names_docs = db_session.query(users_table_md.c.name, users_table_md.c.surname, doctor_table_md.c.degree).filter(
        and_(users_table_md.c.email.in_(list),doctor_table_md.c.email.in_(list))).limit(len(list))
            
    result=[]
    for doc in names_docs:
        result.append([doc])        
    
            
    return print("Here are such doctors: {}".format(result))


# In[19]:


query3()


# ### *4. Below is everything related to the 4th Query*

# In[20]:


# Query 4. For each country list the cname and average salary of doctors who are specialized in “virology”.
def query4():
    list = db_session.query(disease_table_md.c.id).filter(disease_table_md.c.pathogen == 'virus').all()
    virus = []
    for x in list:
        virus.append([x[0]])
    
    id_docs = db_session.query(specialize_table_md.c.email).filter(specialize_table_md.c.id.in_(virus)).all()
    ids = []
    for x in id_docs:
        ids.append([x[0]])

    info_docs = db_session.query(users_table_md.c.cname, func.avg(users_table_md.c.salary)).group_by(users_table_md.c.cname).filter(users_table_md.c.email.in_(ids)).all()
    result = []
    
    for inf in info_docs:
        result.append([inf[0] +" - "+ str(int(inf[1]))])
        
    return print("Here are such countries: {}".format(result))


# In[21]:


query4()


# ### *5. Below is everything related to the 5th Query*

# In[ ]:


# 5. List the departments of public servants who report “covid-19” cases in more than one country and 
# the number of such public servants who work in these departments. (i.e “Dept1 3” means that in the “Dept1” 
# department there are 3 such employees.)


# In[ ]:


# This query is written in raw SQL and executed though a SQLAlchemy Python interface. I liked it this way.


# In[22]:


def query5():
    with db_engine.connect() as con:
        command = con.execute(
                "SELECT PublicServant.Department, COUNT(DISTINCT Record.email) "       
                "FROM PublicServant, Record "         
                "WHERE Record.disease_code = 'covid-19' AND PublicServant.email = Record.email "
                "GROUP BY PublicServant.Department "        
                "HAVING COUNT(Record.cname) >= 2")
        for row in command:
            print(row)


# In[23]:


#There are three employees from Dept1 who have recorded Covid-19 cases in more than one country

query5()


# ### *6. Below is everything related to the 6th Query.*

# In[24]:


# a command to update the salary of a user whose salary will be changed in the query
# just helps to keep things near and organized in case anything goes wrong

# I know the names of these employees, so I explicitly update them

users_table_md.update().values(salary=150000).where(users_table_md.c.name == 'Jalen').execute()
users_table_md.update().values(salary=250000).where(users_table_md.c.name == 'James').execute()
db_session.commit()


# In[25]:


# Query 6. Double the salary of public servants who have recorded covid-19 patients more than 3 times.
three_and_more = db_session.query(records_table_md.c.email).group_by(records_table_md.c.email).having(func.count(records_table_md.c.disease_code=="covid-19") >= 3)

# function to check salary before pandemic
def query6_before():
    salary = db_session.query(users_table_md.c.salary).filter(users_table_md.c.email.in_(three_and_more)).all()
    print("Salary before updating:{}".format(salary))

# function to check salary after pandemic
def query6_after():
    users_table_md.update().values(salary=(users_table_md.c.salary)*2).where(users_table_md.c.email.in_(three_and_more)).execute()
    db_session.commit()

    salary = db_session.query(users_table_md.c.salary).filter(users_table_md.c.email.in_(three_and_more)).all()
    
    print("Salary after updating:{}".format(salary))


# In[26]:


query6_before()


# In[27]:


query6_after()


# ### *7. Below is everything related to the 7th Query.*

# In[28]:


from sqlalchemy import delete


# In[ ]:


# Query 7. Delete the users whose name contain the substring “bek” or “gul” (e.g. Alibek, Gulsim)


# In[29]:


def query7_before():
    bek = db_session.query(users_table_md.c.name).filter(func.upper(users_table_md.c.name).contains('BEK')==True).all()
    gul = db_session.query(users_table_md.c.name).filter(func.upper(users_table_md.c.name).contains('GUL')==True).all()
    
    print("Before deleting names. BEK: {}, GUL: {}".format(bek,gul))


# In[30]:


query7_before()


# In[31]:


def query7_after():
    bek = db_session.query(users_table_md.c.name).filter(func.upper(users_table_md.c.name).contains('BEK')==True).all()
    gul = db_session.query(users_table_md.c.name).filter(func.upper(users_table_md.c.name).contains('GUL')==True).all()
    
    with db_engine.begin() as conn:
        result = conn.execute(
            delete(users_table_md).where(users_table_md.c.name.contains('gul')))
    with db_engine.begin() as conn:
        result = conn.execute(
            delete(users_table_md).where(users_table_md.c.name.contains('bek')))
    db_session.commit()
    print("After deleting names. BEK: {}, GUL: {}".format(bek,gul))


# In[33]:


# gotta run it two times so the results will update
query7_after()


# ### *8. Below is everything related to the 8th Query*

# In[34]:


import sqlalchemy


# In[35]:


# 8. Create an index, namely “idx pathogen” on the “pathogen” field.
def query8():
    sqlalchemy.Index("idx_pathogen", disease_table_md.c.pathogen, unique=True)
    stmt = sqlalchemy.Index("idx_pathogen", disease_table_md.c.pathogen, unique=True)
    db_session.commit()

    print("This index has been created: {}".format(stmt))


# In[36]:


query8()


# In[37]:


# Note in the example above, the Index construct is created externally to the table which it corresponds, 
# using Column objects directly


# ### *9. Below is everything related to the 9th Query*

# In[40]:


# Query 9. List the email, name, and department of public servants who have 
# created records where the number of patients is between 100000 and 999999

def query9():
    list = db_session.query(records_table_md.c.email).filter(records_table_md.c.total_patients.between(100000, 999999)).all()
    needed_recs = []
    for x in list:
        needed_recs.append([x[0]])
    
    info_servant = db_session.query(public_servant_table_md.c.email, users_table_md.c.name, public_servant_table_md.c.department).filter(
        and_(public_servant_table_md.c.email.in_(needed_recs),users_table_md.c.email.in_(needed_recs))).limit(len(needed_recs)).all()
    
    result = []
    for doc in info_servant:
        result.append(doc)

    return print("Here are the email, name, and department of such servants: {}".format(result))


# In[41]:


query9()


# ### *10. Below is everything related to the 10th Query*

# In[42]:


# Query 10. List the top 5 counties with the highest number of total patients recorded.
def query10():
    list = db_session.query(records_table_md.c.cname).group_by(records_table_md.c.cname).order_by(func.count(records_table_md.c.total_patients)).limit(5)
    countries = []
    for x in list:
        countries.append([x[0]])
    
    return print("These countries have the highest number of patients: {}".format(countries))


# In[43]:


query10()


# ### *11. Below is Everything related to the 11th Query*

# In[ ]:


#Query 11. Group the diseases by disease type and the total number of patients treated.


# In[ ]:


# This query is written in raw SQL and executed though a SQLAlchemy Python interface. I liked it this way.


# In[44]:


# here in the GROUP BY clause, Disease.id is the same as DiseaseType.id, which signifies a type of the disease
def query11():
    with db_engine.connect() as con:
        query = con.execute(
                "SELECT DiseaseType.description, Record.total_patients "
                "FROM DiseaseType, Record, Disease "
                "WHERE DiseaseType.id = Disease.id AND Disease.disease_code = Record.disease_code " 
                "GROUP BY DiseaseType.description")
        for row in query:
            print(row)


# In[45]:


query11()

