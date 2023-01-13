import java.awt.AWTException;

import java.awt.Robot;

public final class JavaRobotExample{ public static void main(String[] args) throws AWTException { Robot robot = new Robot(); robot.setAutoDelay(5); robot.setAutoWaitForIdle(true); while(true){ robot.mouseMove(20, 20); robot.delay(15000); robot.mouseMove(200, 10); robot.delay(15000); robot.mouseMove(40, 130); } //System.exit(0);
                                                                                                                                                                                                                                                                                                                      }}
