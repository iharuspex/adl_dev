with HAL.Bitmap;              use HAL.Bitmap;
with Bitmapped_Drawing;
with Bitmap_Color_Conversion; use Bitmap_Color_Conversion;

package body Screen is

   LCD_Natural_Width  : constant Natural := 128;
   LCD_Natural_Height : constant Natural := 32;

   Current_Font : constant BMP_Font := Default_Font;

   Char_Width  : constant Natural := BMP_Fonts.Char_Width (Current_Font);
   Char_Height : constant Natural := BMP_Fonts.Char_Height (Current_Font);

   Max_Width  : constant Natural := LCD_Natural_Width - Char_Width;
   Max_Height : constant Natural := LCD_Natural_Height - Char_Height;

   Current_Y : Natural := 0;

   Char_Count : Natural := 0;

   ----------
   -- Init --
   ----------

   procedure Init is
   begin
      SSD1306.Initialize (My_Screen, False);
      SSD1306.Initialize_Layer (My_Screen, 1, M_1);
      SSD1306.Turn_On (My_Screen);
      SSD1306.Hidden_Buffer (My_Screen, 1).Set_Source
        (Current_Background_Color);
      SSD1306.Hidden_Buffer (My_Screen, 1).Fill;
      SSD1306.Update_Layer (My_Screen, 1);
   end Init;

   ------------------
   -- Clear_Screen --
   ------------------

   procedure Clear_Screen is
   begin
      My_Screen.Hidden_Buffer (1).Set_Source (Current_Background_Color);
      My_Screen.Hidden_Buffer (1).Fill;
      My_Screen.Update_Layer (1);
   end Clear_Screen;

   ---------------
   -- Draw_Char --
   ---------------

   procedure Draw_Char (X, Y : Natural; Msg : Character) is
   begin
      Bitmapped_Drawing.Draw_Char
        (My_Screen.Hidden_Buffer (1).all, Start => (X, Y), Char => Msg,
         Font                                   => Current_Font,
         Foreground => Bitmap_Color_To_Word (M_1, Current_Text_Color),
         Background => Bitmap_Color_To_Word (M_1, Current_Background_Color));
   end Draw_Char;

   ------------------
   -- Internal_Put --
   ------------------

   procedure Internal_Put (Msg : Character) is
      X : Natural;
   begin
      if Char_Count * Char_Width > Max_Width then

         Current_Y := Current_Y + Char_Height;
         if Current_Y > Max_Height then
            Current_Y := 0;
         end if;
         X          := 0;
         Char_Count := 0;
      else
         X := Char_Count * Char_Width;
      end if;

      Draw_Char (X, Current_Y, Msg);
      Char_Count := Char_Count + 1;
   end Internal_Put;

   ------------------
   -- Internal_Put --
   ------------------

   procedure Internal_Put (Msg : String) is
   begin
      for C of Msg loop
         if C = ASCII.LF then
            New_Line;
         else
            Internal_Put (C);
         end if;
      end loop;
   end Internal_Put;

   ---------
   -- Put --
   ---------

   procedure Put (Msg : Character) is
   begin
      Internal_Put (Msg);
      My_Screen.Update_Layer (1);
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (Msg : String) is
   begin
      Internal_Put (Msg);
      My_Screen.Update_Layer (1);
   end Put;

   --------------
   -- New_Line --
   --------------

   procedure New_Line is
   begin
      Char_Count := 0;
      if Current_Y + Char_Height > Max_Height then
         Current_Y := 0;
      else
         Current_Y := Current_Y + Char_Height;
      end if;
   end New_Line;

   --------------
   -- Put_Line --
   --------------

   procedure Put_Line (Msg : String) is
   begin
      Put (Msg);
      New_Line;
   end Put_Line;

   ---------
   -- Put --
   ---------

   procedure Put (X, Y : Natural; Msg : Character) is
   begin
      Draw_Char (X, Y, Msg);
      My_Screen.Update_Layer (1);
   end Put;

   ---------
   -- Put --
   ---------

   procedure Put (X, Y : Natural; Msg : String) is
      Count  : Natural := 0;
      Next_X : Natural;
   begin
      for C of Msg loop
         Next_X := X + (Count * Char_Width);
         Draw_Char (Next_X, Y, C);
         Count := Count + 1;
      end loop;
      My_Screen.Update_Layer (1);
   end Put;

end Screen;
