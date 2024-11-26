#define _CRT_SECURE_NO_WARNINGS 1
#include<stdio.h>
#include<stdlib.h>
#include<time.h>
#include<conio.h>

int u; // 全區變量

int same(int num[]); // 函數聲明

void menu() // 函數聲明
{
    printf("Guess Number Game\n\n");
    printf("1. Start Game\n\n");
    printf("2. Help\n\n");
    printf("3. Exit\n\n");
    printf("Please enter (1-3): ");
}

// 主函數
int main()
{
    void help(); // 函數聲明
    void game(int a[]); // 函數聲明

    int k = 0, select = 0;
    int a[4] = { 0 };
    srand((unsigned)time(NULL)); // 隨機數種，只調用一次即可
    menu();
    scanf("%d", &select);
    while (select != 3)
    {
        switch (select)
        {
        case 1: { system("cls"); game(a); break; } // 開始遊戲
        case 2: { system("cls"); help(); _getch(); system("cls"); menu(); break; } // 幫助
        default: printf("Invalid input, please re-enter!"); break; // 輸入1.2.以外的數
        }
        scanf("%d", &select);
    }
    return 0;
}

void help() // 遊戲規說明函數
{
    printf("\t\t\tWelcome to the program\n\n\n");
    printf("Game Instructions: Enter a four-digit number, after entering, a hint of XAYB will appear.\n");
    printf("X indicates how many digits are correct and in the correct position.\n");
    printf("Y indicates how many digits are correct but in the wrong position.\n");
    printf("Press any key to continue............\n");
}

void game(int a[]) // 比較用戶輸入數和隨機數，並產生提示訊息
{
    int b[4] = {0};
    int i = 0, j = 0;
    while (1)
    {
        // 生成4個隨機數字
        do
        {
            for (i = 0; i < 4; i++)
                a[i] = rand() % 10;
            same(a);
        } while (u); // 此處使用全局變量u
        if (a[0] != 0)
            break;
    }
    int k = 1, A = 0, B = 0, N = 8, pick = 0;
    printf("Please input your guess of the four digits\n");
    while (A != 4 && k <= N)
    {
        A = 0, B = 0;
        printf("Attempt %d: ", k);
        scanf("%d", &pick); // 玩家從鍵盤輸入數據
        while (pick < 999 || pick > 10000)
        {
            printf("Invalid input!\n");
            scanf("%d", &pick);
        }
        for (i = 3; i >= 0; i--)
        {
            b[i] = pick % 10;
            pick = pick / 10;
        }
        // 比較對應位置上的數字
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
            printf("Congratulations, game successful!\n");
        }
        k++;
    }
    if (A != 4 && k > 8)
    {
        printf("Game failed!\n");
        printf("The correct answer is: ");
        for (i = 0; i < 4; i++)
            printf("%d", a[i]);
        printf("\n");
    }
    printf("Enter 1 to continue the game, enter 2 to return to the menu, enter 0 to exit the game: ");
    while (1)
    {
        scanf("%d", &pick);
        if (pick == 2)
        {
            system("cls");
            menu();
            int select = 0;
            while (select != 3)
            {
                switch (select)
                {
                case 1: { system("cls"); game(a); break; }
                case 2: { system("cls"); help(); _getch(); system("cls"); menu(); break; }
                default: printf("Invalid input, please re-enter!"); break;
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
            printf("Invalid input, please re-enter!\n");
    }
}

int same(int num[]) // 判斷產生的隨機數各個位置上有沒有重複的函數
{
    u = 0; // 注意u是全局變量
    for (int i = 0; i < 3; i++)
        for (int j = i + 1; j < 4; j++)
            if (num[i] == num[j])
                u = 1;
    return u;
}
