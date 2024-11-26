#define _CRT_SECURE_NO_WARNINGS 1
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<conio.h>
int u; //全區變量
int same(int num[]);//函數聲明
void menu()//函數聲明
{
	printf("\t\t\t\t猜數字遊戲\n\n\n\n");
	printf("\t\t\t\t1.開始遊戲\n\n");
	printf("\t\t\t\t2.幫助\n\n");
	printf("\t\t\t\t3.退出\n\n");
	printf("\t\t\t請輸入（1-3）：");
}
//主函數
int main()
{
	void help();//函数声明
	void game(int a[]);//函數聲明
 
	int  k = 0, select=0;
	int a[4] = { 0 };
	srand((unsigned)time(NULL));//隨機數種，只調用一次即可
	menu();
	scanf("%d", &select);
	while (select!= 3)
	{
		switch (select)
		{
		case 1: {system("cls"); game(a); break; } //開始遊戲
		case 2: {system("cls"); help(); _getch(); system("cls"); menu(); break; } //幫助
		default:printf("輸入不合法，請重新輸入!"); break; //輸入1.2.以外的數
		}
		scanf("%d", &select);
	}
	return 0;
}
 
void help()//遊戲規說明函數
{
	printf("\t\t\t歡迎使用本程序\n\n\n");
	printf("遊戲說明：輸入四位數字，輸入後有提示XAYB，X表示有幾個數字與答案數字相同且位置相同。\n");
	printf("Y表示有幾位數字與答案數字相同但位置不正確。\n");
	printf("按任意鍵繼續............\n");
}
 
void game(int a[])//比較用戶輸入數四和隨機數，並產生提示訊息
{
	int b[4] = {0};
	int i = 0, j = 0;
	while (1)
	{
		//生成4個隨機數字
		do
		{
			for (i = 0; i < 4; i++)
				a[i] = rand() % 10;
			same(a);
		} while (u);//此處使用全局變量u
		if (a[0] != 0)
			break;
	}
	int k = 1, A = 0, B = 0, N = 8 ,pick = 0;
	printf("請輸入猜想的四位數\n");
	while (A != 4 && k <= N)
	{
		A = 0, B = 0;
		printf("第%d次：", k);
		scanf("%d", &pick);//玩家从键盘输入数据
		while (pick < 999 || pick>10000)
		{
			printf("输入不合法！\n");
			scanf("%d", &pick);
		}
		for (i = 3; i >= 0; i--)
		{
			b[i] = pick % 10;
			pick = pick/ 10;
		}
		//比较对应位置上的数
		for (i = 0; i < 4; i++)
			for (j = 0; j < 4; j++)
				if (a[i] == b[j])
					if (i == j)
						A++;
					else
						B++;
		printf("%dA%dB\n", A, B);
		if (A == 4)
		{
			printf("恭喜，游戏成功！\n");
		}
		k++;
	}
	if (A != 4 && k > 8)
	{
		printf("游戏失败！\n");
		printf("正确答案是：");
		for (i = 0; i < 4; i++)
			printf("%d", a[i]);
		printf("\n");
	}
	printf("输入 1 继续游戏，输入 2 返回菜单，输入 0 退出游戏：");
	while (1)
	{
		scanf("%d", &pick);
		if (pick == 2)
		{
			system("cls"); menu();
			int select=0;
			while (select != 3)
			{
				switch (select)
				{
				case 1: {system("cls"); game(a); break; }
				case 2: {system("cls"); help(); _getch(); system("cls"); menu(); break; }
				default:printf("输入不合法，请重新输入!"); break;
				}
				scanf("%d", &select);
			}
			exit(0);
		}
		else if (pick == 1)
		{
			system("cls");
			game(a);
		}
		else if (pick == 0)
			exit(0);
		else
			printf("输入错误，请重新输入！\n");
	}
}
 
int same(int num[])//判断产生的随机数各个位置上有没有重复的函数
{
	u = 0;//注意u是全局变量
	for (int i = 0; i < 3; i++)
		for (int j = i + 1; j < 4; j++)
			if (num[i] == num[j])
				u = 1;
	return u;
}