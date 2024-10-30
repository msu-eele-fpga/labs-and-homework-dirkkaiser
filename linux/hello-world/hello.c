#include <linux/init.h>
#include <linux/module.h>

MODULE_AUTHOR("Dirk Kaiser");
MODULE_DESCRIPTION("Homework 8: Linux Kernal Module - Hello");
MODULE_VERSION("1.0");
MODULE_LICENSE("Dual MIT/GPL");

static int __init init_hello(void)
{
    printk("Hello world\n");
    return 0;
}
static void __exit cleanup_hello(void)
{
    printk("Goodbye, cruel world\n");
}
module_init(init_hello);
module_exit(cleanup_hello);
