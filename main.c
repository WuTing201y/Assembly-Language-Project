#define _CRT_SECURE_NO_WARNINGS 1
#include<stdio.h>
#include<stdlib.h>
#include<conio.h>

int u; //全局變量
int same(int num[]);//函數聲明
void menu();//函數聲明
void progress_bar(int current, int total); //進度條函數聲明

void menu()
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
    void help();//函數聲明
    void game(int a[]);//函數聲明

    int select = 0;
    int a[4] = { 0 };
    menu();
    scanf("%d", &select);
    while (select != 3)
    {
        switch (select)
        {
        case 1: { system("cls"); game(a); break; } //開始遊戲
        case 2: { system("cls"); help(); _getch(); system("cls"); menu(); break; } //幫助
        default: printf("輸入不合法，請重新輸入!\n"); break;
        }
        scanf("%d", &select);
    }
    return 0;
}

void help()
{
    printf("\t\t\t歡迎使用本程序\n\n\n");
    printf("遊戲說明：輸入四位數字，輸入後有提示XAYB，X表示有幾個數字與答案數字相同且位置相同。\n");
    printf("Y表示有幾位數字與答案數字相同但位置不正確。\n");
    printf("按任意鍵繼續............\n");
}

void game(int a[])
{
    int b[4] = { 0 };
    int i = 0, j = 0;
    while (1)
    {
        //生成4個隨機數字
        do
        {
            for (i = 0; i < 4; i++)
                a[i] = rand() % 10;
            same(a);
        } while (u); //使用全局變量u
        if (a[0] != 0)
            break;
    }
    int k = 1, A = 0, B = 0, N = 8, pick = 0;
    printf("請輸入猜想的四位數\n");
    while (A != 4 && k <= N)
    {
        A = 0, B = 0;
        printf("第%d次：", k);
        scanf("%d", &pick);
        while (pick < 999 || pick > 10000)
        {
            printf("輸入不合法！\n");
            scanf("%d", &pick);
        }
        for (i = 3; i >= 0; i--)
        {
            b[i] = pick % 10;
            pick = pick / 10;
        }
        //比較對應位置上的數
        for (i = 0; i < 4; i++)
            for (j = 0; j < 4; j++)
                if (a[i] == b[j])
                    if (i == j)
                        A++;
                    else
                        B++;
        printf("%dA%dB\n", A, B);

        // 顯示進度條
        progress_bar(k, N);

        if (A == 4)
        {
            printf("恭喜，遊戲成功！\n");
        }
        k++;
    }
    if (A != 4 && k > N)
    {
        printf("遊戲失敗！\n");
        printf("正確答案是：");
        for (i = 0; i < 4; i++)
            printf("%d", a[i]);
        printf("\n");
    }
    printf("輸入 1 繼續遊戲，輸入 2 返回菜單，輸入 0 退出遊戲：");
    while (1)
    {
        scanf("%d", &pick);
        if (pick == 2)
        {
            system("cls"); menu();
            break;
        }
        else if (pick == 1)
        {
            system("cls");
            game(a);
        }
        else if (pick == 0)
            exit(0);
        else
            printf("輸入錯誤，請重新輸入！\n");
    }
}
// 顯示進度條函數
void progress_bar(int current, int total)
{
    int percent = (current * 100) / total;
    int bar_width = 50; // 進度條總寬度
    int pos = (current * bar_width) / total;

    printf("[");
    for (int i = 0; i < bar_width; i++)
    {
        if (i < pos)
            printf("=");
        else if (i == pos)
            printf(">");
        else
            printf(" ");
    }
    printf("] 剩下%d次機會\n", 8-current);
}
