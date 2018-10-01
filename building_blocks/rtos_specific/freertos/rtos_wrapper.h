/**
 * @file rtos_wrapper.h
 *
 * RTOS wrapper for FreeRTOS
 *
 * @author German Rivera
 */
#ifndef __RTOS_WRAPPER_H
#define __RTOS_WRAPPER_H

#include <assert.h>
#include <stdint.h>
#include <stdbool.h>
#include <stddef.h>
#include <FreeRTOS.h>
#include <task.h>
#include <semphr.h>
#include <queue.h>
#include <timers.h>
#include "mem_utils.h"

/**
 * For FreeRTOS, lower number means lower priority.
 */
#define HIGHEST_APP_TASK_PRIORITY    (configMAX_PRIORITIES - 1)
#define LOWEST_APP_TASK_PRIORITY     (tskIDLE_PRIORITY + 1)

static_assert(HIGHEST_APP_TASK_PRIORITY > LOWEST_APP_TASK_PRIORITY,
              "HIGHEST_APP_TASK_PRIORITY is wrong");

/**
 * application task default stack size in number of 32-bit entries
 */
#define APP_TASK_STACK_SIZE UINT32_C(256)

static_assert(APP_TASK_STACK_SIZE >= configMINIMAL_STACK_SIZE,
              "APP_TASK_STACK_SIZE is wrong");

static_assert(sizeof(bool) == sizeof(uint8_t), "Unexpected bool size");

/**
 * application task default stack size in bytes
 */
#define APP_TASK_STACK_SIZE_BYTES (APP_TASK_STACK_SIZE * sizeof(uint32_t))

/**
 * Number of milliseconds per RTOS timer tick
 */
#define MS_PER_TIMER_TICK    portTICK_PERIOD_MS

/**
 * Calculate difference between two values of RTOS timer ticks
 */
#define RTOS_TICKS_DELTA(_begin_ticks, _end_ticks) \
        ((uint32_t)((int32_t)(_end_ticks) - (int32_t)(_begin_ticks)))

#define MILLISECONDS_TO_TICKS(_milli_secs) \
        ((uint32_t)HOW_MANY(_milli_secs, MS_PER_TIMER_TICK))

/**
 * Wrapper for an RTOS mutex object
 */
struct rtos_mutex
{
    /**
     * Flag indicating that the OS mutex object has been initialized
     */
    bool mtx_initialized;

    StaticSemaphore_t mtx_os_mutex_var;

    /**
     * Handle returned by xSemaphoreCreateMutexStatic()
     */
    SemaphoreHandle_t mtx_os_mutex_handle;
};

/**
 * Wrapper for an RTOS semaphore object
 */
struct rtos_semaphore
{
    /**
     * Flag indicating that the OS semaphore object has been initialized
     */
    bool sem_initialized;

    StaticSemaphore_t sem_os_semaphore_var;

    /**
     * Handle returned by xSemaphoreCreateBinaryStatic() or
     * xSemaphoreCreateCountingStatic()
     */
    SemaphoreHandle_t sem_os_semaphore_handle;
};

/**
 * Wrapper for an RTOS task object
 */
struct rtos_task
{
    /**
     * Task's stack (must be the first field of the structure)
     */
    StackType_t tsk_stack[APP_TASK_STACK_SIZE];

    /**
     * Flag indicating that the OS task object has been initialized
     */
    bool tsk_initialized;

    /**
     * Task ID assigned by the application
     */
    uint8_t tsk_id;

    /**
     * Maximum number of stack entries used (high water mark)
     */
    uint16_t tsk_max_stack_entries_used;

    /**
     * Task control block
     */
    StaticTask_t tsk_var;

    /**
     * FreeRTOS task handle
     */
    TaskHandle_t tsk_handle;

    /**
     * Task semaphore
     */
    struct rtos_semaphore tsk_semaphore;
};

struct rtos_timer;

/**
 * Signature of a timer callback function
 */
typedef void rtos_timer_callback_t(struct rtos_timer *rtos_timer_p);

/**
 * Wrapper for an RTOS timer object
 */
struct rtos_timer
{
    /**
     * Flag indicating that the OS timer object has been initialized
     */
    bool tmr_initialized;

    StaticTimer_t tmr_os_timer_var;

    /**
     * Handle returned by xTimerCreateStatic()
     */
    TimerHandle_t tmr_os_timer_handle;

    rtos_timer_callback_t *tmr_callback_p;
};

/**
 * Task priority type
 */
typedef UBaseType_t rtos_task_priority_t;

/**
 * RTOS clock tick unit type
 */
typedef TickType_t rtos_ticks_t;

/**
 * Signature of a task function
 */
typedef void rtos_task_function_t(void);

void rtos_init(void);

bool rtos_initialized(void);

void rtos_scheduler_start(void);

bool rtos_scheduler_started(void);

typedef uint8_t rtos_task_id_t;

#define INVALID_TASK_ID UINT8_MAX

void rtos_task_init(struct rtos_task *rtos_task_p,
                    rtos_task_function_t *task_function_p,
                    rtos_task_priority_t task_prio);

rtos_task_id_t rtos_task_self_id(void);

void rtos_task_get_current_stack(uintptr_t *start_addr_p, uint32_t *size_p);

void rtos_task_change_self_priority(rtos_task_priority_t new_task_prio);

void rtos_task_delay_until(rtos_ticks_t *prev_wake_ticks_p, uint32_t ms);

void rtos_task_delay(uint32_t ms);

void rtos_task_semaphore_wait(void);

void rtos_task_semaphore_signal(struct rtos_task *rtos_task_p);

void rtos_mutex_init(struct rtos_mutex *rtos_mutex_p);

void rtos_mutex_lock(struct rtos_mutex *rtos_mutex_p);

void rtos_mutex_unlock(struct rtos_mutex *rtos_mutex_p);

bool rtos_mutex_is_mine(const struct rtos_mutex *rtos_mutex_p);

void rtos_semaphore_init(struct rtos_semaphore *rtos_semaphore_p,
                         uint32_t initial_count);

void rtos_semaphore_wait(struct rtos_semaphore *rtos_semaphore_p);

void rtos_semaphore_wait_timeout(struct rtos_semaphore *rtos_semaphore_p,
				 uint32_t timeout_ms,
                                 uint8_t *status);

void rtos_semaphore_signal(struct rtos_semaphore *rtos_semaphore_p);

uint32_t rtos_semaphore_get_count(const struct rtos_semaphore *rtos_semaphore_p);

void rtos_timer_init(struct rtos_timer *rtos_timer_p,
                     const char *timer_name_p,
                     uint32_t milliseconds,
                     bool periodic,
                     rtos_timer_callback_t *timer_callback_p);

void rtos_timer_start(struct rtos_timer *rtos_timer_p);

void rtos_timer_stop(struct rtos_timer *rtos_timer_p);

bool rtos_task_check_stack(struct rtos_task *task_p);

void rtos_enter_isr(void);

void rtos_exit_isr(void);

rtos_ticks_t rtos_get_ticks_since_boot(void);

uint32_t rtos_get_time_since_boot(void);

uint32_t get_freertos_StaticTask_t_Size(void);

uint32_t get_freertos_StaticSemaphore_t_Size(void);

uint32_t get_freertos_StaticTimer_t_Size(void);

/*
 * FreeRTOS callbacks
 */

void vApplicationGetIdleTaskMemory(StaticTask_t **ppxIdleTaskTCBBuffer,
				   StackType_t **ppxIdleTaskStackBuffer,
				   uint32_t *pulIdleTaskStackSize);

void vApplicationGetTimerTaskMemory(StaticTask_t **ppxTimerTaskTCBBuffer,
		                    StackType_t **ppxTimerTaskStackBuffer,
				    uint32_t *pulTimerTaskStackSize);

#endif /*  __RTOS_WRAPPER_H */
