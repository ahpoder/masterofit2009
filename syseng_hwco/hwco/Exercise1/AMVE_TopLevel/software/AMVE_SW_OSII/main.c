#include <stdio.h>
#include "includes.h"
#include "system.h"

#include <os/alt_sem.h>

/* Definition of Task Stacks */
#define   TASK_STACKSIZE       2048
OS_STK    taskProducer1_stk[TASK_STACKSIZE];
OS_STK    taskProducer2_stk[TASK_STACKSIZE];
OS_STK    taskConsumer_stk[TASK_STACKSIZE];

/* Definition of Task Priorities */

#define TASK_PRODUCER1_PRIORITY      1
#define TASK_PRODUCER2_PRIORITY      2
#define TASK_CONSUMER_PRIORITY      3

//ALT_STATIC_SEM(eventSemaphore)
static OS_EVENT * mailboxSemaphore;
static OS_EVENT * msgqueueSemaphore;
static OS_EVENT* mailBox;
static OS_EVENT* msgQueue;
#define MESSAGE_QUEUE_ENTRY_COUNT 12
static void* msgQueueBuffer[MESSAGE_QUEUE_ENTRY_COUNT];

static unsigned short producer1TaskDelay;
static unsigned short producer2TaskDelay;
static unsigned short consumerTaskDelay;

void taskMailboxProducer(void* pdata)
{
  INT8U res;
  char dataBuffer[64];
  int i = 0;
  while (1)
  {
	// timeout = 0 indicate indefinite
	OSSemPend(mailboxSemaphore, 0, &res);
    if (res == 0)
    {
    	sprintf(dataBuffer, "Hello from Mailbox Process: %d", ++i);
		printf("Adding message to mailbox\n");
    	res = OSMboxPost(mailBox, dataBuffer);
    	if (res != 0)
    	{
		  printf("MailboxProducer: Failure writing to mailbox: %hu\n", res);
    	}
    }
    else
    {
      printf("MailboxProducer: Failure getting semaphore: %hu\n", res);
    }

	  OSTimeDly(producer1TaskDelay);
//    OSTimeDlyHMSM(0, 0, 0, producer1TaskDelay);
  }
}

void taskMessageQueueProducer(void* pdata)
{
  INT8U res;
  char dataBuffer[MESSAGE_QUEUE_ENTRY_COUNT][64];
  int i = 0;
  int messageIndex = 0;
  while (1)
  {
	// timeout = 0 indicate indefinite
	OSSemPend(msgqueueSemaphore, 0, &res);
	if (res == 0)
	{
    	sprintf(dataBuffer[messageIndex], "Hello from Message Queue Process: %d", ++i);
		printf("Adding message to message queue\n");
    	res = OSQPost(msgQueue, dataBuffer[messageIndex]);
		if (res != 0)
		{
		  printf("MessageQueueProducer: Failure writing to Message Queue: %hu\n", res);
		}
    	if (++messageIndex == MESSAGE_QUEUE_ENTRY_COUNT)
    	{
    		messageIndex = 0;
    	}
	}
	else
	{
	  printf("MessageQueueProducer: Failure getting semaphore: %hu\n", res);
	}
	OSTimeDly(producer2TaskDelay);
//    OSTimeDlyHMSM(0, 0, 0, producer2TaskDelay);
  }
}

static void postToSemahore(OS_EVENT* sem, const char* semName)
{
	switch (OSSemPost(sem))
	{
	case OS_NO_ERR:
		printf("Posted to semaphore %s\n", semName);
		break;
	case OS_SEM_OVF:
		printf("Failure posting to semaphore %s, overflow\n", semName);
		break;
	case OS_ERR_EVENT_TYPE:
		printf("Failure posting to semaphore %s, event type error\n", semName);
		break;
	}
}

void taskConsumer(void* pdata)
{
  INT8U errorRet;
  // We could do this with just one variable
  void* mailboxResult;
  void* messagequeueResult;
  while (1)
  {
	  errorRet = 0;
	  // Pend on the mailbox
	  // ticks to ms (max tick = 65535)
	  mailboxResult = OSMboxPend(mailBox, consumerTaskDelay / 2, &errorRet);
	  if (mailboxResult != 0)
	  {
		  printf("Received message from mailbox: %s\n", (const char*)mailboxResult);
		  // As the mailboxResult is a pointer, it is important that the
		  // pointer is not invalidated until we are done with it. We fix this by
		  // waiting until we are done with the pointer to release the mailbox.
		  // This means that the producer only need one pointer for data.
		  postToSemahore(mailboxSemaphore, "mbSem");
	  }
	  else if (errorRet == OS_TIMEOUT) // Timeout
	  {
		  // Do nothing.
	  }
	  else // Error
	  {
		  printf("Error occured waiting on mail box: %d\n", errorRet);
	  }

	  errorRet = 0;
	  // Pend on the message queue
	  // ticks to ms (max tick = 65535)
	  messagequeueResult = OSQPend(msgQueue, consumerTaskDelay / 2, &errorRet);
	  if (messagequeueResult != 0)
	  {
		  printf("Received message from message queue: %s\n", (const char*)messagequeueResult);
		  // As the messagequeueResult is a pointer, it is important that the
		  // pointer is not invalidated until we are done with it. We fix this by
		  // waiting until we are done with the pointer to release the message queue.
		  // This means that the producer "only" need 12 slots for data.
		  postToSemahore(msgqueueSemaphore, "msqSem");
	  }
	  else if (errorRet == OS_TIMEOUT) // Timeout
	  {
		  // Do nothing.
	  }
	  else // Error
	  {
		  printf("Error occured waiting on message queue box: %d\n", errorRet);
	  }

//    OSTimeDlyHMSM(0, 0, 0, consumerTaskDelay);
  }
}

/* The main function creates two task and starts multi-tasking */
int main(void)
{
  //  ALT_SEM_CREATE(eventSemaphore, 0);
  mailboxSemaphore = OSSemCreate(1);
  if (mailboxSemaphore == 0)
  {
	  printf("Failure creating MailBox semaphore\n");
	  return -1;
  }
  msgqueueSemaphore = OSSemCreate(MESSAGE_QUEUE_ENTRY_COUNT);
  if (msgqueueSemaphore == 0)
  {
	  printf("Failure creating MessageQueue semaphore\n");
	  return -1;
  }
  mailBox = OSMboxCreate(NULL);
  if (mailBox == 0)
  {
	  printf("Failure creating MailBox\n");
	  return -1;
  }
  msgQueue = OSQCreate(msgQueueBuffer, MESSAGE_QUEUE_ENTRY_COUNT);
  if (msgQueue == 0)
  {
	  printf("Failure creating MessageQueue\n");
	  return -1;
  }

  printf("Please enter the Producer 1 Task run interval[ticks](0-65535): ");
  scanf("%hu", &producer1TaskDelay);
  printf("Please enter the Producer 2 Task run interval[ticks](0-65535): ");
  scanf("%hu", &producer2TaskDelay);
  printf("Please enter the Consumer Task run interval[ticks](0-65535): ");
  scanf("%hu", &consumerTaskDelay);

  OSTaskCreateExt(taskMailboxProducer,
                  NULL,
                  (void *)&taskProducer1_stk[TASK_STACKSIZE-1],
                  TASK_PRODUCER1_PRIORITY,
                  TASK_PRODUCER1_PRIORITY,
                  taskProducer1_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  OSTaskCreateExt(taskConsumer,
                  NULL,
                  (void *)&taskConsumer_stk[TASK_STACKSIZE-1],
                  TASK_CONSUMER_PRIORITY,
                  TASK_CONSUMER_PRIORITY,
                  taskConsumer_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  OSTaskCreateExt(taskMessageQueueProducer,
                  NULL,
                  (void *)&taskProducer2_stk[TASK_STACKSIZE-1],
                  TASK_PRODUCER2_PRIORITY,
                  TASK_PRODUCER2_PRIORITY,
                  taskProducer2_stk,
                  TASK_STACKSIZE,
                  NULL,
                  0);

  OSStart();
  return 0;
}
