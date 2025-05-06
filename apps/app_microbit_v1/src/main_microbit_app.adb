with MicroBit.IOs;
with MicroBit.Time;
with MicroBit.Console;
with MicroBit.I2C;

with LM75; use LM75;
with I2C_Bus;
with Screen;

procedure Main_Microbit_App is

   Temp_Sensor : LM75_Sensor (MicroBit.I2C.Controller);

   T : Temperature := 0.0;

   type Fixed is delta 0.01 range -1.0e6 .. 1.0e6;

begin
   MicroBit.Console.Put_Line ("*** Microbit Ada App ***");

   I2C_Bus.Initialize;
   I2C_Bus.Scan;

   Temp_Sensor.Set_Address (16#90#);

   Screen.Init;

   loop
      Temp_Sensor.Read_Temperature (T);
      MicroBit.Console.Put ("Temperature = ");
      MicroBit.Console.Put (Fixed (T)'Image);
      MicroBit.Console.Put (ASCII.CR);

      Screen.Put (10, 0, "t=" & Fixed (T)'Image);

      MicroBit.IOs.Set (8, True);
      MicroBit.Time.Delay_Ms (200);
      MicroBit.IOs.Set (8, False);
      MicroBit.Time.Delay_Ms (200);
   end loop;
end Main_Microbit_App;
