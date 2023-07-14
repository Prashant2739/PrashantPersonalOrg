@isTest
private class TaskUtilTest {
    @isTest static void testTaskPriorityN() {
        String pri = TaskUtil.getTaskPriority('NY');
        System.assertEquals('Normal', pri);
    }
    @isTest static void testTaskPriorityP() {
        String pri = TaskUtil.getTaskPriority('ca');
        System.assertEquals('High', pri);
    }
    @isTest static void testTaskPriorityNe() {
        String pri = TaskUtil.getTaskPriority('cap');
        System.assertEquals(null, pri);
    }
}