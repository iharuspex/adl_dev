with HAL.I2C; use HAL.I2C;
--  with Interfaces;
with MicroBit.Time;
with MicroBit.Console;
with MicroBit.I2C;

package body I2C_Bus is

   generic
      type T is mod <>;
   function Hex_Any (hval : T; num_digits : Integer := T'Size / 4)
      return String;

   function Hex_Any (hval : T; num_digits : Integer := T'Size / 4)
      return String
   is
      X : T := hval;
      Hex_Str : String (1 .. num_digits);
      Hex_Digit : constant array (T range 0 .. 15) of Character := "0123456789ABCDEF";
   begin
      for I in reverse Hex_Str'Range loop
         Hex_Str (I) := Hex_Digit(X and 15);
         X := X / 16;
      end loop;

      if X /= 0 then
         raise Program_Error;
      end if;

      return Hex_Str;
   end Hex_Any;

   function Hex is new Hex_Any (HAL.I2C.I2C_Address);

   ----------
   -- Scan --
   ----------

   procedure Scan is
      Address : HAL.I2C.I2C_Address;
      Data    : HAL.I2C.I2C_Data (1 .. 1) := (others => 1);
      Status  : HAL.I2C.I2C_Status;
   begin
      MicroBit.Console.Put_Line ("Scanning I2C bus...");
      for I in 16#00# .. 16#FF# loop
         Address := HAL.I2C.I2C_Address (I);
         MicroBit.I2C.Controller.Master_Receive (Address, Data, Status);

         if Status = HAL.I2C.Ok then
            MicroBit.Console.Put_Line (Hex (Address));
         end if;

         MicroBit.Time.Delay_Ms (5);
      end loop;
      MicroBit.Console.Put_Line ("Scanning completed!");
   end Scan;

   ----------------
   -- Initialize --
   ----------------

   procedure Initialize is
   begin
      if not MicroBit.I2C.Initialized then
         MicroBit.I2C.Initialize (MicroBit.I2C.S400kbps);
      end if;
   end Initialize;

end I2C_Bus;