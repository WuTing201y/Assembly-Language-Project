#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define GRID_SIZE 3  // 地圖大小 (3x3)
#define MAX_ROUNDS 5 // 最大回合數

// 函數宣告
void printGrid(int grid[GRID_SIZE][GRID_SIZE]);
void generateMole(int grid[GRID_SIZE][GRID_SIZE]);
int playerTurn(int grid[GRID_SIZE][GRID_SIZE]);

int main() {
    int playAgain = 1; // 控制是否繼續遊戲

    srand(time(NULL)); // 初始化隨機數生成器

    printf("歡迎來到打地鼠遊戲！\n");
    printf("地圖大小為 %dx%d，每回合隨機出現一隻地鼠。\n", GRID_SIZE, GRID_SIZE);

    while (playAgain) {
        int grid[GRID_SIZE][GRID_SIZE] = {0}; // 初始化地圖為空
        int score = 0; // 玩家得分
        int rounds = 0; // 已進行回合數

        time_t startTime, endTime; // 宣告用於計時的變數

        time(&startTime); // 記錄遊戲開始時間

        // 遊戲主迴圈
        while (rounds < MAX_ROUNDS) {
            printf("\n第 %d 回合：\n", rounds + 1);

            // 產生地鼠
            generateMole(grid);

            // 顯示地圖
            printGrid(grid);

            // 玩家行動
            score += playerTurn(grid);

            // 回合數 +1
            rounds++;
        }

        time(&endTime); // 記錄遊戲結束時間
        double elapsedTime = difftime(endTime, startTime); // 計算花費的時間

        printf("\n遊戲結束！您的總得分是：%d/%d\n", score, MAX_ROUNDS);
        printf("您完成此局花費的時間為 %.2f 秒。\n", elapsedTime);

        // 問玩家是否再來一局
        printf("是否要再來一局？(1: 是, 0: 否)：");
        scanf("%d", &playAgain);
    }

    printf("感謝遊玩！再見！\n");
    return 0;
}

// 顯示地圖
void printGrid(int grid[GRID_SIZE][GRID_SIZE]) {
    printf("地圖：\n");
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            if (grid[i][j] == 1) {
                printf("[*] "); // 地鼠位置
            } else {
                printf("[ ] "); // 空白
            }
        }
        printf("\n");
    }
}

// 隨機生成地鼠位置
void generateMole(int grid[GRID_SIZE][GRID_SIZE]) {
    // 清空地圖
    for (int i = 0; i < GRID_SIZE; i++) {
        for (int j = 0; j < GRID_SIZE; j++) {
            grid[i][j] = 0;
        }
    }
    // 隨機選擇地鼠位置
    int moleRow = rand() % GRID_SIZE;
    int moleCol = rand() % GRID_SIZE;
    grid[moleRow][moleCol] = 1;
}

// 玩家行動
int playerTurn(int grid[GRID_SIZE][GRID_SIZE]) {
    int row, col;
    printf("請輸入您要打的行與列（以空格分隔，從 1 開始計算）：");
    scanf("%d %d", &row, &col);

    // 將使用者輸入的直覺行列轉換為程式內部的索引
    row--;
    col--;

    if (row >= 0 && row < GRID_SIZE && col >= 0 && col < GRID_SIZE) {
        if (grid[row][col] == 1) {
            printf("打中了！\n");
            return 1; // 得分
        } else {
            printf("沒打中。\n");
        }
    } else {
        printf("輸入無效，請輸入正確的行與列。\n");
    }
    return 0; // 未得分
}
