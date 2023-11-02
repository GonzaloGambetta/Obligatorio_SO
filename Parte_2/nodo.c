#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>

sem_t semBD, semCE, semHG, semDF, semEF, semEG, semFQ, semGQ, semQI, semQJ, semQK, semIL, semIM, semJM, semLN, semMP, semNO, semPO;

void *Proc_A(void *x) {
    printf("A\n");
}

void *Proc_B(void *x) {
    printf("B\n");
    sem_post(&semBD);
}

void *Proc_C(void *x) {
    printf("C\n");
    sem_post(&semCE);
}

void *Proc_H(void *x) {
    printf("H\n");
    sem_post(&semHG);
}

void *ProcD(void* x) {
    sem_wait(&semBD);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("D\n");
    sem_post(&semDF);
}

void *ProcE(void* x) {
    sem_wait(&semCE);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("E\n");
    sem_post(&semEF);
    sem_post(&semEG);
}

void *ProcF(void* x) {
    sem_wait(&semDF);
    sem_wait(&semEF);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("F\n");
    sem_post(&semFQ);
}

void *ProcG(void* x) {
    sem_wait(&semEG);
    sem_wait(&semHG);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("G\n");
    sem_post(&semGQ);
}

void *ProcQ(void* x) {
    sem_wait(&semFQ);
    sem_wait(&semGQ);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("Q\n");
    sem_post(&semQI);
    sem_post(&semQJ);
    sem_post(&semQK);
}

void *ProcK(void* x) {
    sem_wait(&semQK);
    printf("K\n");
}

void *ProcJ(void* x) {
    sem_wait(&semQJ);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("J\n");
    sem_post(&semJM);
}

void *ProcI(void* x) {
    sem_wait(&semQI);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("I\n");
    sem_post(&semIL);
    sem_post(&semIM);
}

void *ProcL(void* x) {
    sem_wait(&semIL);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("L\n");
    sem_post(&semLN);
}

void *ProcM(void* x) {
    sem_wait(&semIM);
    sem_wait(&semJM);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("M\n");
    sem_post(&semMP);
}

void *ProcN(void* x) {
    sem_wait(&semLN);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("N\n");
    sem_post(&semNO);
}

void *ProcP(void* x) {
    sem_wait(&semMP);
    srand(time(NULL));
    sleep(1 + (rand() % 5));
    printf("P\n");
    sem_post(&semPO);
}

void *ProcO(void* x) {
    sem_wait(&semNO);
    sem_wait(&semPO);
    printf("O\n");
}

int main() {
    sem_init(&semBD, 0, 0);
    sem_init(&semCE, 0, 0);
    sem_init(&semDF, 0, 0);
    sem_init(&semEF, 0, 0);
    sem_init(&semEG, 0, 0);
    sem_init(&semHG, 0, 0);
    sem_init(&semFQ, 0, 0);
    sem_init(&semGQ, 0, 0);
    sem_init(&semQI, 0, 0);
    sem_init(&semQJ, 0, 0);
    sem_init(&semQK, 0, 0);
    sem_init(&semIL, 0, 0);
    sem_init(&semIM, 0, 0);
    sem_init(&semJM, 0, 0);
    sem_init(&semLN, 0, 0);
    sem_init(&semMP, 0, 0);
    sem_init(&semNO, 0, 0);
    sem_init(&semPO, 0, 0);
}