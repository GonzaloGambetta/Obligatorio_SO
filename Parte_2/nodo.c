#include <pthread.h>
#include <semaphore.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>


sem_t semBD, semCE, semHG, semDF, semEF, semEG, semFQ, semGQ, semQI, semQJ, semQK, semIL, semIM, semJM, semLN, semMP, semNO, semPO;

void *ProcA(void *x){
    printf("A\n");
}

void *ProcB(void *x){
    printf("B\n");
    sem_post(&semBD);
}

void *ProcC(void *x){
    printf("C\n");
    sem_post(&semCE);
}

void *ProcH(void *x){
    printf("H\n");
    sem_post(&semHG);
}

void *ProcD(void* x){
    sem_wait(&semBD);
    printf("D\n");
    sem_post(&semDF);
}

void *ProcE(void* x){
    sem_wait(&semCE);
    printf("E\n");
    sem_post(&semEF);
    sem_post(&semEG);
}

void *ProcF(void* x){
    sem_wait(&semDF);
    sem_wait(&semEF);
    printf("F\n");
    sem_post(&semFQ);
}

void *ProcG(void* x){
    sem_wait(&semEG);
    sem_wait(&semHG);
    printf("G\n");
    sem_post(&semGQ);
}

void *ProcQ(void* x){
    sem_wait(&semFQ);
    sem_wait(&semGQ);
    printf("Q\n");
    sem_post(&semQI);
    sem_post(&semQJ);
    sem_post(&semQK);
}

void *ProcK(void* x){
    sem_wait(&semQK);
    printf("K\n");
}

void *ProcJ(void* x){
    sem_wait(&semQJ);
    printf("J\n");
    sem_post(&semJM);
}

void *ProcI(void* x){
    sem_wait(&semQI);
    printf("I\n");
    sem_post(&semIL);
    sem_post(&semIM);
}

void *ProcL(void* x){
    sem_wait(&semIL);
    printf("L\n");
    sem_post(&semLN);
}

void *ProcM(void* x){
    sem_wait(&semIM);
    sem_wait(&semJM);
    printf("M\n");
    sem_post(&semMP);
}

void *ProcN(void* x){
    sem_wait(&semLN);
    printf("N\n");
    sem_post(&semNO);
}

void *ProcP(void* x){
    sem_wait(&semMP);
    printf("P\n");
    sem_post(&semPO);
}

void *ProcO(void* x){
    sem_wait(&semNO);
    sem_wait(&semPO);
    printf("O\n");
}

int main(){
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

    pthread_t ta, tb, tc, td, te, tf, tg, th, ti, tj, tk, tl, tm, tn, to, tp, tq;
    pthread_attr_t attr;
    pthread_attr_init(&attr);

    pthread_create(&ta, &attr, ProcA, NULL);
    pthread_create(&tb, &attr, ProcB, NULL);
    pthread_create(&tc, &attr, ProcC, NULL);
    pthread_create(&td, &attr, ProcD, NULL);
    pthread_create(&te, &attr, ProcE, NULL);
    pthread_create(&tf, &attr, ProcF, NULL);
    pthread_create(&tg, &attr, ProcG, NULL);
    pthread_create(&th, &attr, ProcH, NULL);
    pthread_create(&ti, &attr, ProcI, NULL);
    pthread_create(&tj, &attr, ProcJ, NULL);
    pthread_create(&tk, &attr, ProcK, NULL);
    pthread_create(&tl, &attr, ProcL, NULL);
    pthread_create(&tm, &attr, ProcM, NULL);
    pthread_create(&tn, &attr, ProcN, NULL);
    pthread_create(&to, &attr, ProcO, NULL);
    pthread_create(&tp, &attr, ProcP, NULL);
    pthread_create(&tq, &attr, ProcQ, NULL);

    pthread_join(ta, NULL);
    pthread_join(tb, NULL);
    pthread_join(tc, NULL);
    pthread_join(td, NULL);
    pthread_join(te, NULL);
    pthread_join(tf, NULL);
    pthread_join(tg, NULL);
    pthread_join(th, NULL);
    pthread_join(ti, NULL);
    pthread_join(tj, NULL);
    pthread_join(tk, NULL);
    pthread_join(tl, NULL);
    pthread_join(tm, NULL);
    pthread_join(tn, NULL);
    pthread_join(to, NULL);
    pthread_join(tp, NULL);
    pthread_join(tq, NULL);

    return 0;
}