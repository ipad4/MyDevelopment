//
//  Extern_Static_base.c
//  HanyCLanguageDemo
//
//  Created by 冯鸿辉 on 16/6/27.
//  Copyright © 2016年 MD. All rights reserved.
//

#include "Extern_Static_base.h"
#include "MD_C_Keyword3_CFile.h"

void Extern_Static_base_root(){
  
}

#pragma mark - ********** knowledge **************
#pragma mark - extern、static

//extern关键字
/*
 如果想在同一个项目中共享全局变量，
 1.变量所在文件的.h公开.c的变量，用extern修饰；使用变量的文件中，include头文件
 或者
 2.在使用变量的文件中，要使用extern关键字声明全局变量才可使用，并且可以得到全局变量的值
 */
#include "MD_C_Keyword1_CFile.h"//对应上面1
extern char *name_Keyword;//对应上面2
extern int i;//对应上面2


//static关键字
/*
 被修饰的变量只能该文件使用
 */
static double money_Keyword = 100.1;

void cKeywordTest0()
{
  printf("age:%d\n",age_Keyword);//在定义变量的文件中使用extern
  printf("name:%s\n",name_Keyword);//在使用“外部变量”的文件中使用extern
  printf("money:%f\n",money_Keyword);//static
  printf("i:%d\n",i);
}

#pragma mark - auto与static
void cKeywordTest1()
{
  cKeyword3Test();
}


#pragma mark - *********** practice **************