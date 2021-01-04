--  Copyright (c) 2021, Karsten Lüth (kl@kloc-consulting.de)
--  All rights reserved.
--
--  Redistribution and use in source and binary forms, with or without
--  modification, are permitted provided that the following conditions are met:
--
--  1. Redistributions of source code must retain the above copyright notice,
--     this list of conditions and the following disclaimer.
--
--  2. Redistributions in binary form must reproduce the above copyright notice,
--     this list of conditions and the following disclaimer in the documentation
--     and/or other materials provided with the distribution.
--
--  3. Neither the name of the copyright holder nor the names of its
--     contributors may be used to endorse or promote products derived from
--     this software without specific prior written permission.
--
--  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
--  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
--  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
--  ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE
--  LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
--  CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
--  SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS;
--  OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY,
--  WHETHER IN CONTRACT, STRICT LIABILITY,
--  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
--  USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

package body MB_Accel is

   procedure Read_Register (Port     : Any_I2C_Port;
                            Dev_Addr : I2C_Address;
                            Addr     : UInt16;
                            Success  : out Boolean;
                            Value    : out UInt8);
   function Check_MMA8653 (Port : Any_I2C_Port) return Boolean;
   function Check_LSM303 (Port : Any_I2C_Port)  return Boolean;
   function Check_FXOS8700 (Port : Any_I2C_Port)  return Boolean;

   procedure Read_Register (Port     : Any_I2C_Port;
                            Dev_Addr : I2C_Address;
                            Addr     : UInt16;
                            Success  : out Boolean;
                            Value    : out UInt8)
   is
      Data   : I2C_Data (1 .. 1);
      Status : I2C_Status;
   begin
      Port.Mem_Read (Addr          => Dev_Addr,
                     Mem_Addr      => Addr,
                     Mem_Addr_Size => Memory_Size_8b,
                     Data          => Data,
                     Status        => Status);

      if Status /= Ok then
         Success := False;
      else
         Success := True;
         Value  := Data (Data'First);
      end if;
   end Read_Register;

   function Check_MMA8653 (Port : Any_I2C_Port) return Boolean
   is
      Success : Boolean;
      Value   : UInt8;
   begin
      Read_Register (Port, 16#3A#, 16#0D#, Success, Value);
      return Success and Value = 16#5A#;
   end Check_MMA8653;

   function Check_LSM303 (Port : Any_I2C_Port)  return Boolean
   is
      Success : Boolean;
      Value   : UInt8;
   begin
      Read_Register (Port, 16#32#, 16#0F#, Success, Value);
      return Success and Value = 16#33#;
   end Check_LSM303;

   function Check_FXOS8700 (Port : Any_I2C_Port)  return Boolean
   is
      Success : Boolean;
      Value   : UInt8;
   begin
      Read_Register (Port, 16#3C#, 16#0D#, Success, Value);
      return Success and Value = 16#C7#;
   end Check_FXOS8700;

   function Detect_Accelerometer (Port : Any_I2C_Port) return Accelerometer is
   begin
      if Check_MMA8653 (Port) then
         return MMA8653;
      elsif Check_LSM303 (Port) then
         return LSM303;
      elsif Check_FXOS8700 (Port) then
         return FXOS8700;
      else
         return Unknown_Accel;
      end if;
   end Detect_Accelerometer;

end MB_Accel;
