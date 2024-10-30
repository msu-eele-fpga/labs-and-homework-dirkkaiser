static int __init init_hello(void)
{
    printk("Hello world\n");
    return 0;
}
static void __exit cleanup_hello(void)
{
    printk("Goodbye, cruel world\n");
    return 0;
}

MODULE_AUTHOR("Dirk Kaiser");
MODULE_DESCRIPTION("Linux Kernal Module Homework");
MODULE_VERSION("1");
MODULE_LICENSE("Dual MIT/GPL");
module_init(init_hello);
module_exit(cleanup_hello);
