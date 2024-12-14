#include<stdio.h>
#include<stdlib.h>
#include<time.h>

int u; // 全區變量
void creatNUM(int randNum[]);
int same(int num[]); // 函數聲明
void progress_bar(int current, int total);

// 主函數
int main()
{
    void menu();
    void help(); // 函數聲明
    void game(int randNum[]); // 函數聲明

    int select = 0;
    int randNum[4] = { 0 };
    srand((unsigned)time(NULL)); // 隨機數種，只調用一次即可
    menu();
    scanf("%d", &select);
    while (select != 3)
    {   switch (select){
        case 1: { game(randNum); break; } // 開始遊戲
        case 2: { help(); break; } // 幫助
        case 3: { break;} //退出遊戲
        default: printf("Invalid input! Please enter (1-3): "); break; // 輸入1.2.3.以外的數
        }
        if (select != 3){
            scanf("%d", &select);
        }
        else break;
    }
    return 0;
}
void menu() // 函數聲明
{
    printf("Guess Number Game\n");
    printf("1. Start Game\n");
    printf("2. Help\n");
    printf("3. Exit\n");
    printf("Please enter (1-3): ");
}

void help() // 遊戲規說明函數
{
    printf("Welcome to the program\n");
    printf("Game Instructions: Enter a four-digit number, after entering, a hint of XAYB will appear.\n");
    printf("X indicates how many digits are correct and in the correct position.\n");
    printf("Y indicates how many digits are correct but in the wrong position.\n");
    printf("Press 1 to continue the game: ");
}

void game(int randNum[]) // 比較用戶輸入數和隨機數，並產生提示訊息
{   int getNum[4] = {0};

    creatNUM(randNum);

    int tryCase = 1, A = 0, B = 0, total = 8, pick = 0;
    printf("Please input your guess of the four digits:\n");
    while (A != 4 && tryCase <= total){
        A = 0, B = 0;

        scanf("%d", &pick); // 玩家從鍵盤輸入數據
        while (pick < 1000 || pick > 9999){
            printf("Invalid input!\n");
            scanf("%d", &pick);
        }
        for (int i = 3; i >= 0; i--){
            getNum[i] = pick % 10;
            pick = pick / 10;
        }
        // 比較對應位置上的數字
        for (int i = 0; i < 4; i++){
            for (int j = 0; j < 4; j++){
                if (randNum[i] == getNum[j]){
                    if (i == j) A++;
                    else B++;
                }
            }
        }
        printf("%dA%dB\n", A, B);
        progress_bar(tryCase, total);
        printf("\n");
        if (A == 4){
            printf("Congratulations, game successful!\n");
        }
        tryCase++;
    }
    if (A != 4 && tryCase > 8){
        puts("");
        printf("Game failed!\n");
        printf("The correct answer is: ");
        for (int i = 0; i < 4; i++)
            printf("%d", randNum[i]);
        printf("\n\n");
    }
    printf("Enter 1 to continue the game, enter 0 to exit the game: ");
    while (1){
        scanf("%d", &pick);
        if (pick == 1) game(randNum);
        else if (pick == 0){
            printf("Thanks for playing!\n");
            exit(0);
        }
        else printf("Invalid input! Please enter (1-3): ");
    }
}
void creatNUM(int randNum[])
{
    while (1)
    {// 生成4個隨機數字
        do{
            for (int i = 0; i < 4; i++)
                randNum[i] = rand() % 10;
            same(randNum);
        } while (u); //u=1時，重新生成
        if (randNum[0] != 0)
            break;
    }
}
int same(int num[]) // 判斷產生的隨機數各個位置上有沒有重複的函數
{   u = 0;
    for (int i = 0; i < 3; i++)
        for (int j = i + 1; j < 4; j++)
            if (num[i] == num[j])
                u = 1;
    return u;
}

// 顯示進度條函數
void progress_bar(int current, int total)
{
    int bar_width = 50; // 進度條總寬度
    int pos = (current * bar_width) / total;

    printf("[");
    for (int i = 0; i < bar_width; i++) {
        if (i < pos - 1)  // 填滿的部分
            printf("=");
        else if (i == pos - 1 && current < total)
            printf(">");
        else if (i == bar_width - 1 && current == total)
            printf(">");
        else  // 剩餘空格
            printf(" ");
    }
    printf("] %d chances left\n", 8 - current);
}
