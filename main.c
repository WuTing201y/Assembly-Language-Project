#define _CRT_SECURE_NO_WARNINGS 1
#include<stdio.h>
#include<stdlib.h>
#include<conio.h>

int u; //�����ܶq
int same(int num[]);//����n��
void menu();//����n��
void progress_bar(int current, int total); //�i�ױ�����n��

void menu()
{
    printf("\t\t\t\t�q�Ʀr�C��\n\n\n\n");
    printf("\t\t\t\t1.�}�l�C��\n\n");
    printf("\t\t\t\t2.���U\n\n");
    printf("\t\t\t\t3.�h�X\n\n");
    printf("\t\t\t�п�J�]1-3�^�G");
}

//�D���
int main()
{
    void help();//����n��
    void game(int a[]);//����n��

    int select = 0;
    int a[4] = { 0 };
    menu();
    scanf("%d", &select);
    while (select != 3)
    {
        switch (select)
        {
        case 1: { system("cls"); game(a); break; } //�}�l�C��
        case 2: { system("cls"); help(); _getch(); system("cls"); menu(); break; } //���U
        default: printf("��J���X�k�A�Э��s��J!\n"); break;
        }
        scanf("%d", &select);
    }
    return 0;
}

void help()
{
    printf("\t\t\t�w��ϥΥ��{��\n\n\n");
    printf("�C�������G��J�|��Ʀr�A��J�ᦳ����XAYB�AX��ܦ��X�ӼƦr�P���׼Ʀr�ۦP�B��m�ۦP�C\n");
    printf("Y��ܦ��X��Ʀr�P���׼Ʀr�ۦP����m�����T�C\n");
    printf("�����N���~��............\n");
}

void game(int a[])
{
    int b[4] = { 0 };
    int i = 0, j = 0;
    while (1)
    {
        //�ͦ�4���H���Ʀr
        do
        {
            for (i = 0; i < 4; i++)
                a[i] = rand() % 10;
            same(a);
        } while (u); //�ϥΥ����ܶqu
        if (a[0] != 0)
            break;
    }
    int k = 1, A = 0, B = 0, N = 8, pick = 0;
    printf("�п�J�q�Q���|���\n");
    while (A != 4 && k <= N)
    {
        A = 0, B = 0;
        printf("��%d���G", k);
        scanf("%d", &pick);
        while (pick < 999 || pick > 10000)
        {
            printf("��J���X�k�I\n");
            scanf("%d", &pick);
        }
        for (i = 3; i >= 0; i--)
        {
            b[i] = pick % 10;
            pick = pick / 10;
        }
        //���������m�W����
        for (i = 0; i < 4; i++)
            for (j = 0; j < 4; j++)
                if (a[i] == b[j])
                    if (i == j)
                        A++;
                    else
                        B++;
        printf("%dA%dB\n", A, B);

        // ��ܶi�ױ�
        progress_bar(k, N);

        if (A == 4)
        {
            printf("���ߡA�C�����\�I\n");
        }
        k++;
    }
    if (A != 4 && k > N)
    {
        printf("�C�����ѡI\n");
        printf("���T���׬O�G");
        for (i = 0; i < 4; i++)
            printf("%d", a[i]);
        printf("\n");
    }
    printf("��J 1 �~��C���A��J 2 ��^���A��J 0 �h�X�C���G");
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
            printf("��J���~�A�Э��s��J�I\n");
    }
}

int same(int num[])
{
    u = 0;
    for (int i = 0; i < 3; i++)
        for (int j = i + 1; j < 4; j++)
            if (num[i] == num[j])
                u = 1;
    return u;
}

// ��ܶi�ױ����
void progress_bar(int current, int total)
{
    int percent = (current * 100) / total;
    int bar_width = 50; // �i�ױ��`�e��
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
    printf("] �ѤU%d�����|\n", 8-current);
}
