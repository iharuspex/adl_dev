with SSD1306;   use SSD1306;
with MicroBit.Time;
with MicroBit.I2C;
with HAL.Time;
with BMP_Fonts; use BMP_Fonts;
with HAL.Bitmap;

package Screen is
   HAL_Time  : constant HAL.Time.Any_Delays := MicroBit.Time.HAL_Delay;
   My_Screen :
     SSD1306_Screen
       ((128 * 32) / 8, 128, 32, MicroBit.I2C.Controller,
        MicroBit.MB_P12'Access, HAL_Time);

   Black : HAL.Bitmap.Bitmap_Color renames HAL.Bitmap.Black;
   White : HAL.Bitmap.Bitmap_Color renames HAL.Bitmap.White;

   Default_Text_Color       : constant HAL.Bitmap.Bitmap_Color := White;
   Default_Background_Color : constant HAL.Bitmap.Bitmap_Color := Black;
   Default_Font             : constant BMP_Font                := Font12x12;

   Current_Text_Color       : HAL.Bitmap.Bitmap_Color := Default_Text_Color;
   Current_Background_Color : HAL.Bitmap.Bitmap_Color :=
     Default_Background_Color;

   procedure Clear_Screen;

   procedure Put_Line (Msg : String);

   procedure Put (Msg : String);

   procedure Put (Msg : Character);

   procedure New_Line;

   procedure Put (X, Y : Natural; Msg : Character);

   procedure Put (X, Y : Natural; Msg : String);

   procedure Init;

end Screen;
