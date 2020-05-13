public with sharing class WrapperClassTwoObject {

public list<wrapperClass> getListWrapperObjectMethod()
{
objList1=[Select name,testfield1__c from Testobject1__c limit 1];
objList2=[Select name,testfield1__c from Testobject2__c limit 1];
for(integer i=0;i<objList1.size();i++)
{
wrapperClassList.add(new wrapperCLass(objList1[i].name,objList1[i].testfield1__c,objList2[i].name,objList2[i].testfield1__c ));
}
return wrapperClassList;
}

public class wrapperClass
{


public string name{get;set;}
public string fieldDataOne{get;set;}
public string name1{get;set;}
public string fieldDataTwo{get;set;}


public wrapperCLass(string name,string fieldDataOne,string name1,string fieldDataTwo)
{
this.name=name;
this.fieldDataOne=fieldDataOne;
this.name1=name1;
this.fieldDataTwo=fieldDataTwo;

}
}
}