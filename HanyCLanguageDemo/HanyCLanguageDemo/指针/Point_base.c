//
//  Point_base.c
//  HanyCLanguageDemo
//
//  Created by 冯鸿辉 on 16/6/27.
//  Copyright © 2016年 MD. All rights reserved.
//

#include "Point_base.h"
#include <string.h>


int * point_point();
void point_point_1();
void point_void_0();
void point_test_1_1();
void point_test_0_1();


void Point_base_root(){

 
}

#pragma mark - ********** knowledge **************
#pragma mark - 指针的创建、指针的大小、指针做函数返回值
//指针的创建、指针的大小
void point_init(){
  
  int x =10,y = 20;
  int *p1,*p2;
  p1 = &x;
  p2 = &y;
  
  printf("p1->x's value:%d\np2->y's value:%d\n",*p1,*p2);
  
  //可以给指针指向的值赋值(以下两种方法都可以)
  //    *p1 = 30;
  //    *p2 = 40;
  *&x = 30;
  *&y = 40;
  printf("p1->x's value:%d\np2->y's value:%d\n",*p1,*p2);
  
  //指针占用的空间是固定的64位系统下8个字节
  printf("p1:%ld,p2:%ld",sizeof(p1),sizeof(p2));
}

//指针做函数返回值
int* point_return(){
  
  int i = 10;
  int* p = &i;
  printf("i address:%p\n",&i);
  return p;
}

#pragma mark - 数组与指针
void point_address(){
  
  //整形数组与指针
  int arr[5] = {1,2,3,4,5};
  int *p;//int类型指针所指向的内存大小为4字节
  p = arr;
  
  /*
   每个元素的地址是该元素的首地址
   数组名 = 数组的第一个元素的地址 = 第一个元素的首地址 = 数组的首地址
   */
  printf("arr[0]->address:%p\n",&arr[0]);
  printf("p->address:%p\n",p);
  
  /*
   假设指针类型与数组类型为int，则A指针的下一个不是内存地址+1，而是数组的下一个元素的地址
   因为每个元素所占内存空间与指针所指向的内存空间一样大，而且数组用首地址代表每个元素的地址
   */
  for (int i=0; i<5; i++) {
    printf("p[%d]->address:%p\n",i,(p+i));
  }
}

void point_char(){
  
  //字符数组与指针
  char arr2[5] = {'a','b','c','d','e'};
  char *p2;//char类型的指针所指向的内存大小为1字节
  p2 = arr2;
  
  for (int i=0; i<5; i++) {
    printf("p2->address:%p\n",(p2+i));
    
    printf("p2->value:%d\n",*(p2+i));
    printf("p2->char:%c\n",*(p2+i));
    
    printf("arr2[%d]->value:%d\n",i,arr2[i]);
    printf("arr2[%d]->char:%c\n",i,arr2[i]);
    printf("arr2[%d]->char:%c\n",i,*(arr2+i));//数组名实际上是一个指针，指向该数组首元素内存地址
    
    printf("\n");
  }
}

#pragma mark - 数组与指针的运算
//只有在同一数组下，+i、-i、++、--、p1-p2（可以求两个指针之间有多少个元素）有意义，p1+p2无意义
void point_calucate(){
  
  int arr[4] = {1,2,3,4};
  int *p = arr;
  
  printf("---%d\n",*p);
  printf("arr[0]:%d\n",arr[0]);
  printf("p:%p\n",p);
  
  printf("---%d\n",*p);
  printf("*p++:%d\n",*p++);//顺序相当于：temp=p,p=p+1,*temp,i++比*优先级更高
  printf("p:%p\n",p);
  p = arr;
  
  printf("---%d\n",*p);
  printf("*(p++):%d\n",*(p++));//顺序相当于：temp=p,p=p+1,*temp,i++比*优先级更高
  printf("p:%p\n",p);
  p = arr;
  
  printf("---%d\n",*p);
  printf("*++p:%d\n",*++p);//顺序相当于：p=p+1,*p,++i与*优先级相同，右结合性
  printf("p:%p\n",p);
  p = arr;
  
  printf("---%d\n",*p);
  printf("*(++p):%d\n",*(++p));//顺序相当于：p=p+1,*p,++i与*优先级相同，右结合性
  printf("p:%p\n",p);
  p = arr;
  
  printf("---%d\n",*p);
  printf("(*p)++:%d\n",(*p)++);//顺序相当于：*p==1,1++==1
  printf("p:%p\n",p);
  p = arr;
  
#warning 未知为何为3
  printf("---%d\n",*p);
  printf("++(*p):%d\n",++(*p));
  printf("p:%p\n",p);
  p = arr;
}

#pragma mark - 指针函数与函数指针
void point_func(){
  
  //函数指针是指向函数的指针变量，即本质是一个指针变量
  //函数名相当于地址，由于malloc分配堆内存时，不确定内存存储类型，所以可以用void*代表任意指针类型
  printf("func:%p\n&func:%p\n",point_point_1,&point_point_1);
  
  void(*func_ptr)(int x);
  func_ptr = point_point_1;
  
  void *f2;
  f2 = point_point_1;
}

//指针函数是指带指针的函数，即本质是一个函数。函数返回类型是某一类型的指针。
int * point_point_0(int x){
  
  int *p = &x;
  return p;
}

void point_point_1(int i){
  
  printf("函数运行了%d\n",i);
}

#pragma mark - void* 任意类型指针
typedef enum {
  INT,
  SHORT,
  CHAR
} type;

void point_void(){
  
  int i = 10;
  short s = 5;
  char c = 'c';
  
  point_void_0(&i,INT);
  point_void_0(&s,SHORT);
  point_void_0(&c,CHAR);
}

void point_void_0(void *p,type t){
  
  switch (t) {
    case INT:
      printf("%d\n",*(const int*)p);//因为void*为任意类型指针，使用前要先强制转换为const int*型指针，再引用值
      break;
    case SHORT:
      printf("%d\n",*(const short*)p);
      break;
    case CHAR:
      printf("%c\n",*(const char*)p);
      break;
    default:
      break;
  }
  
}
#pragma mark - *********** practice **************

#pragma mark - 输入两个数，逆向输出

void point_test_0(){
  
  int x = 10,y = 20;
  printf("p1->x's value:%d\tp2->y'value:%d\n",x,y);
  point_test_0_1(&x, &y);
  printf("p1->x's value:%d\tp2->y'value:%d\n",x,y);
}

void point_test_0_1(int *p1,int *p2){
  
  int temp = 0;
  temp = *p1;
  *p1 = *p2;
  *p2 = temp;
}

#pragma mark - 输出数组中的最大值和最小值

void point_test_1(){
  
  int num[5] = {0};
  int max= -10000,min = 10000;
  
  for (int i=0; i<5; i++) {
    printf("请输入第%d个数字：\n",i+1);
    scanf("%d",&num[i]);
  }
  
  point_test_1_1(num,5,&max,&min);
  printf("max:%d\n",max);
  printf("min:%d\n",min);
}

void point_test_1_1(int *arr,int size,int *max, int *min){
  
  for (int i=0; i<5; i++) {
    if (*(arr+i)>*max) {//arr[i]相当于*(arr+i)
      *max=*(arr+i);
    }
    if (*(arr+i)<*min) {
      *min=*(arr+i);
    }
  }
}
