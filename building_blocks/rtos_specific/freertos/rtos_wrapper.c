/**
 * @file rtos_wrapper.c
 *
 * RTOS wrapper implementation for FreeRTOS APIs
 *
 * @author German Rivera
 */

#include "rtos_wrapper.h"
#include <stddef.h>

/*
 * Check sizes of FreeRTOS strucutures used in Ada code
 */
uint32_t get_freertos_StaticTask_t_Size(void) {
  static_assert(sizeof(StaticTask_t) == 120, "Wrong size of StaticTask_t");
  return sizeof(StaticTask_t);
}

uint32_t get_freertos_StaticSemaphore_t_Size(void) {
  static_assert(sizeof(StaticSemaphore_t) == 80, "Wrong size of StaticSemaphore_t");
  return sizeof(StaticSemaphore_t);
}

uint32_t get_freertos_StaticTimer_t_Size(void) {
  static_assert(sizeof(StaticTimer_t) == 44, "Wrong size of StaticTimer_t");
  return sizeof(StaticTimer_t);
}

#define FATAL_ERROR() __gnat_last_chance_handler(__FILE__, __LINE__)

/**
 * Available stack space left when the stack is considered at risk of stack
 * overflow: 10%
 */
#define APP_TASK_STACK_UNFILLED_LIMIT   (APP_TASK_STACK_SIZE / 10)

enum rtos_states {
    NOT_INITIALIZED = 0,
    INITIALIZED,
    SCHED_STARTED
};

struct rtos {
    /**
     * RTOS run state
     */
    enum rtos_states state;

    /**
     * Counter of nested ISRs
     */
    volatile uint8_t nested_ISR_count;

    /**
     * Task ID for the next task to be initialized
     */
    rtos_task_id_t next_task_id;

    /**
     * Flag to track when a task context switch needs to be done during
     * an ISR exit
     */
    BaseType_t task_context_switch_required;

#if 0
    /**
     * saved writable state for the global background data region, for each possible
     * interrupted context for nested interrupts.
     */
    bool interrupted_background_region_writable_state[MCU_NUM_INTERRUPT_PRIORITIES];
#endif
};

static struct rtos g_rtos = {
    .state = NOT_INITIALIZED,
    .nested_ISR_count = 0,
    .next_task_id = 0,
    .task_context_switch_required = pdFALSE,
};

bool rtos_initialized(void)
{
    return g_rtos.state >= INITIALIZED;
}

bool rtos_scheduler_started(void)
{
    return g_rtos.state == SCHED_STARTED;
}

/**
 * Initializes RTOS
 */
void rtos_init(void)
{
    g_rtos.state = INITIALIZED;
}


/**
 * Starts RTOS scheduler
 */
void rtos_scheduler_start(void)
{
    g_rtos.state = SCHED_STARTED;
    vTaskStartScheduler();
    /*Unreachable*/
}


/**
 * Notify RTOS that we are entering an ISR
 */
void rtos_enter_isr(void)
{

#if 0
    bool old_writable = set_writable_background_region(true);
#endif

    portDISABLE_INTERRUPTS();
    uint_fast8_t prev_nested_ISR_count = g_rtos.nested_ISR_count ++;
    portENABLE_INTERRUPTS();

    configASSERT(prev_nested_ISR_count < UINT8_MAX);

#if 0
    g_rtos.interrupted_background_region_writable_state[prev_nested_ISR_count] = old_writable;

    (void)set_writable_background_region(false);
#endif
}


/**
 * Notify RTOS that we are exiting an ISR
 */
void rtos_exit_isr(void)
{
#if 0
    bool old_writable = set_writable_background_region(true);
    configASSERT(!old_writable);
#endif

    portDISABLE_INTERRUPTS();
    uint_fast8_t prev_nested_ISR_count = g_rtos.nested_ISR_count --;
    portENABLE_INTERRUPTS();

    configASSERT(prev_nested_ISR_count >= 1);
    if (prev_nested_ISR_count == 1) {
        if (g_rtos.task_context_switch_required) {
            portYIELD();
            g_rtos.task_context_switch_required = pdFALSE;
        }
    }

#if 0
    (void)set_writable_background_region(
    	g_rtos.interrupted_background_region_writable_state[prev_nested_ISR_count - 1]);
#endif
}


static void rtos_task_internal_callback(void *task_func_addr)
{
    rtos_task_function_t *const task_func_p =
       (rtos_task_function_t *)task_func_addr;

    task_func_p();
}

/**
 * Create an RTOS-level task
 */
void rtos_task_init(struct rtos_task *rtos_task_p,
                    rtos_task_function_t *task_function_p,
                    rtos_task_priority_t task_prio)
{
#if 0
    struct mpu_region_descriptor old_region;
    bool old_write_enabled;
#endif

    configASSERT(rtos_task_p != NULL);
    configASSERT(task_function_p != NULL);
    configASSERT(task_prio >= LOWEST_APP_TASK_PRIORITY &&
                 task_prio <= HIGHEST_APP_TASK_PRIORITY);
#if 0
    set_private_data_region(rtos_task_p, sizeof(*rtos_task_p), READ_WRITE, &old_region);
#endif
    rtos_task_p->tsk_initialized = true;
    configASSERT(g_rtos.next_task_id < INVALID_TASK_ID - 1);
    rtos_task_p->tsk_id = g_rtos.next_task_id ++;
    rtos_task_p->tsk_max_stack_entries_used = 0;

    /*
     * Create the FreeRTOS task:
     */
#if 0
    old_write_enabled = set_writable_background_region(true);
#endif
    rtos_task_p->tsk_handle = xTaskCreateStatic(rtos_task_internal_callback,
    						NULL,
						APP_TASK_STACK_SIZE,
	                                        task_function_p,
						task_prio,
						rtos_task_p->tsk_stack,
						&rtos_task_p->tsk_var);

    if (rtos_task_p->tsk_handle == NULL) {
        FATAL_ERROR();
    }

    vTaskSetApplicationTaskTag(rtos_task_p->tsk_handle, (void *)rtos_task_p);
#if 0
    (void)set_writable_background_region(old_write_enabled);
#endif

    rtos_semaphore_init(&rtos_task_p->tsk_semaphore, 0);
}


/**
 * Returns the pointer to the current task
 *
 * @return task object pointer
 */
static struct rtos_task *rtos_task_get_current(void)
{
    TaskHandle_t task_handle = xTaskGetCurrentTaskHandle();
    struct rtos_task *task_p = (void *)xTaskGetApplicationTaskTag(task_handle);

    return task_p;
}

/**
 * Returns the Id of the calling task
 *
 * @return task Id
 */
rtos_task_id_t rtos_task_self_id(void)
{
    if (g_rtos.nested_ISR_count != 0) {
        /*
         * Caller is an exception handler:
         */
        return INVALID_TASK_ID;
    }

    struct rtos_task *const task_p = rtos_task_get_current();

    return task_p->tsk_id;
}

/**
 * Returns the address range of the current task's stack
 *
 * @param start_addr_p Area where the stack's start address is to be
 *                     returned
 * @param size_p Area where the stack's size (in bytes) is to be
 *                     returned
 */
void rtos_task_get_current_stack(uintptr_t *start_addr_p, uint32_t *size_p)
{
    struct rtos_task *const task_p = rtos_task_get_current();

    *start_addr_p = (uintptr_t)task_p->tsk_stack;
    *size_p = sizeof(task_p->tsk_stack);
}

/**
 * Changes the priority of the calling task
 *
 * @param new_task_prio new task priority
 */
void rtos_task_change_self_priority(rtos_task_priority_t new_task_prio)
{
    TaskHandle_t task_handle = xTaskGetCurrentTaskHandle();

    vTaskPrioritySet(task_handle, new_task_prio);
}


/**
 * Delays the current task a given number of milliseconds from the
 * number of ticks specified in *prev_wake_ticks_p and updates
 * *prev_wake_ticks_p with the current number of ticks upon return
 */
void rtos_task_delay_until(rtos_ticks_t *prev_wake_ticks_p, uint32_t ms)
{
    configASSERT(ms != 0);
    vTaskDelayUntil(prev_wake_ticks_p, ms / MS_PER_TIMER_TICK);
}

/**
 * Delays the current task a given number of milliseconds
 */
void rtos_task_delay(uint32_t ms)
{
  configASSERT(ms != 0);
  vTaskDelay(ms / MS_PER_TIMER_TICK);
}


/**
 * Block calling task on its built-in semaphore
 */
void rtos_task_semaphore_wait(void)
{
    if (g_rtos.nested_ISR_count != 0) {
	FATAL_ERROR();
    }

    struct rtos_task *const task_p = rtos_task_get_current();

    rtos_semaphore_wait(&task_p->tsk_semaphore);
}


/**
 * Wake up a task by signaling its built-in semaphore
 */
void rtos_task_semaphore_signal(struct rtos_task *rtos_task_p)
{
    configASSERT(rtos_task_p != NULL);
    rtos_semaphore_signal(&rtos_task_p->tsk_semaphore);
}


/**
 * Initializes an RTOS-level mutex
 */
void rtos_mutex_init(struct rtos_mutex *rtos_mutex_p)
{
#if 0
    struct mpu_region_descriptor old_region;
#endif

    configASSERT(rtos_mutex_p != NULL);
#if 0
    set_private_data_region(rtos_mutex_p, sizeof(*rtos_mutex_p), READ_WRITE, &old_region);

    bool old_writable = set_writable_background_region(true);
#endif
    rtos_mutex_p->mtx_os_mutex_handle =
	xSemaphoreCreateMutexStatic(&rtos_mutex_p->mtx_os_mutex_var);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    configASSERT(rtos_mutex_p->mtx_os_mutex_handle != NULL);
    rtos_mutex_p->mtx_initialized = true;

#if 0
    restore_private_data_region(&old_region);
#endif
}


/**
 * Acquire an RTOS-level mutex
 */
void rtos_mutex_lock(struct rtos_mutex *rtos_mutex_p)
{
    BaseType_t rtos_status;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_status = xSemaphoreTake(rtos_mutex_p->mtx_os_mutex_handle, portMAX_DELAY);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    if (rtos_status != pdPASS) {
        FATAL_ERROR();
    }
}


/**
 * Release a RTOS-level mutex
 */
void rtos_mutex_unlock(struct rtos_mutex *rtos_mutex_p)
{
    BaseType_t rtos_status;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_status = xSemaphoreGive(rtos_mutex_p->mtx_os_mutex_handle);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    if (rtos_status != pdPASS) {
        FATAL_ERROR();
    }
}


/**
 * Tell if the calling task owns a given mutex
 */
bool rtos_mutex_is_mine(const struct rtos_mutex *rtos_mutex_p)
{
    TaskHandle_t owner =
        xSemaphoreGetMutexHolder(rtos_mutex_p->mtx_os_mutex_handle);

    return owner == xTaskGetCurrentTaskHandle();
}

/**
 * Initializes an RTOS-level semaphore
 */
void rtos_semaphore_init(struct rtos_semaphore *rtos_semaphore_p,
                         uint32_t initial_count)
{
#if 0
    bool old_writable = set_writable_background_region(true);
#endif

    configASSERT(rtos_semaphore_p != NULL);
    if (initial_count == 0) {
	rtos_semaphore_p->sem_os_semaphore_handle =
	   xSemaphoreCreateBinaryStatic(
		&rtos_semaphore_p->sem_os_semaphore_var);
    } else {
	rtos_semaphore_p->sem_os_semaphore_handle =
	    xSemaphoreCreateCountingStatic(
		initial_count, initial_count,
		&rtos_semaphore_p->sem_os_semaphore_var);
    }

#if 0
    (void)set_writable_background_region(old_writable);
#endif

    configASSERT(rtos_semaphore_p->sem_os_semaphore_handle != NULL);
    rtos_semaphore_p->sem_initialized = true;
}


/**
 * Waits on an RTOS-level semaphore
 */
void rtos_semaphore_wait(struct rtos_semaphore *rtos_semaphore_p)
{
    BaseType_t rtos_status;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_status = xSemaphoreTake(rtos_semaphore_p->sem_os_semaphore_handle,
	                         portMAX_DELAY);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    if (rtos_status != pdPASS) {
        FATAL_ERROR();
    }
}


/**
 * Waits with timeout on an RTOS-level semaphore
 *
 * @param rtos_semaphore_p  pointer to the semaphore
 * @param timeout_ms        timeout in milliseconds
 * @param success           *status is set to 1 if the semaphore was
 *                          signaled before the timeout expired, or if
 *                          timeout_ms is 0 and the semaphore count > 0.
 *                          Otherwise, *success is set to 0.
 */
void rtos_semaphore_wait_timeout(struct rtos_semaphore *rtos_semaphore_p,
				 uint32_t timeout_ms,
                                 uint8_t *status)
{
    BaseType_t rtos_status;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_status = xSemaphoreTake(rtos_semaphore_p->sem_os_semaphore_handle,
                                 timeout_ms / MS_PER_TIMER_TICK);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    *status = (rtos_status == pdPASS);
}


/**
 * Signal an RTOS-level semaphore. It wakes up the highest priority waiter
 */
void rtos_semaphore_signal(struct rtos_semaphore *rtos_semaphore_p)
{
#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    if (g_rtos.nested_ISR_count == 0) {
        (void)xSemaphoreGive(rtos_semaphore_p->sem_os_semaphore_handle);
    } else {
        (void)xSemaphoreGiveFromISR(rtos_semaphore_p->sem_os_semaphore_handle,
                                    &g_rtos.task_context_switch_required);
    }
#if 0
    (void)set_writable_background_region(old_writable);
#endif
}

/**
 * Returns the current count of a given counting semaphore
 */
uint32_t rtos_semaphore_get_count(const struct rtos_semaphore *rtos_semaphore_p)
{
    return uxSemaphoreGetCount(rtos_semaphore_p->sem_os_semaphore_handle);
}

static void rtos_timer_internal_callback(TimerHandle_t xTimer)
{
    struct rtos_timer *rtos_timer_p = pvTimerGetTimerID(xTimer);

    rtos_timer_p->tmr_callback_p(rtos_timer_p);
}


/**
 * Initializes an RTOS-level timer
 */
void rtos_timer_init(struct rtos_timer *rtos_timer_p,
                     const char *timer_name_p,
                     uint32_t milliseconds,
                     bool periodic,
                     rtos_timer_callback_t *timer_callback_p)
{
    TickType_t ticks;

    configASSERT(milliseconds >= MS_PER_TIMER_TICK);
    ticks = milliseconds / MS_PER_TIMER_TICK;

    configASSERT(rtos_timer_p != NULL);
    rtos_timer_p->tmr_callback_p = timer_callback_p;
    rtos_timer_p->tmr_initialized = true;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_timer_p->tmr_os_timer_handle =
	xTimerCreateStatic(timer_name_p,
                           ticks,
                           periodic,
                           rtos_timer_p,
                           rtos_timer_internal_callback,
			   &rtos_timer_p->tmr_os_timer_var);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    configASSERT(rtos_timer_p->tmr_os_timer_handle != NULL);
}


/**
 * Starts an RTOS-level timer
 */
void rtos_timer_start(struct rtos_timer *rtos_timer_p)
{
    BaseType_t rtos_status;

#if 0
    bool old_writable = set_writable_background_region(true);
#endif
    rtos_status = xTimerStart(rtos_timer_p->tmr_os_timer_handle,
	                      portMAX_DELAY);
#if 0
    (void)set_writable_background_region(old_writable);
#endif

    if (rtos_status != pdPASS) {
        FATAL_ERROR();
    }
}


/**
 * Stops an RTOS-level timer
 */
void rtos_timer_stop(struct rtos_timer *rtos_timer_p)
{
	BaseType_t rtos_status;

#if 0
	bool old_writable = set_writable_background_region(true);
#endif
	rtos_status = xTimerStop(rtos_timer_p->tmr_os_timer_handle,
		                 portMAX_DELAY);
#if 0
	(void)set_writable_background_region(old_writable);
#endif

	if (rtos_status != pdPASS) {
		FATAL_ERROR();
	}
}


/**
 * Check if stack overflow has occurred on the task stack.
 * It updates task-p->tsk_max_stack_entries_used.
 */
bool rtos_task_check_stack(struct rtos_task *task_p)
{
    UBaseType_t high_water_mark;

    configASSERT(task_p->tsk_initialized);

    high_water_mark = uxTaskGetStackHighWaterMark(task_p->tsk_handle);
	task_p->tsk_max_stack_entries_used = APP_TASK_STACK_SIZE - high_water_mark;

    /*
     * Stack overflow detected
     */
    return (high_water_mark == 0);
}

/**
 * Return Time since boot in ticks
 */
uint32_t rtos_get_ticks_since_boot(void)
{
    return xTaskGetTickCount();
}


/**
 * Return Time since boot in seconds
 */
uint32_t rtos_get_time_since_boot(void)
{
    return rtos_get_ticks_since_boot() / configTICK_RATE_HZ;
}

/*
 *  Callbacks invoked from FreeRTOS
 */

void vApplicationGetIdleTaskMemory(StaticTask_t **ppxIdleTaskTCBBuffer,
				   StackType_t **ppxIdleTaskStackBuffer,
				   uint32_t *pulIdleTaskStackSize)
{
	static struct rtos_task idle_task;

	*ppxIdleTaskTCBBuffer = &idle_task.tsk_var;
	*ppxIdleTaskStackBuffer = idle_task.tsk_stack;
	*pulIdleTaskStackSize =
		sizeof(idle_task.tsk_stack) / sizeof(idle_task.tsk_stack[0]);
}

void vApplicationGetTimerTaskMemory(StaticTask_t **ppxTimerTaskTCBBuffer,
		                    StackType_t **ppxTimerTaskStackBuffer,
				    uint32_t *pulTimerTaskStackSize)
{
	static struct rtos_task timer_task;

	*ppxTimerTaskTCBBuffer = &timer_task.tsk_var;
	*ppxTimerTaskStackBuffer = timer_task.tsk_stack;
	*pulTimerTaskStackSize =
		sizeof(timer_task.tsk_stack) / sizeof(timer_task.tsk_stack[0]);
}
