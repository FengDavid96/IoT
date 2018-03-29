// EXO 9

// The absolute maximum for any single IO pin is 40 mA.

// The total current from all the IO pins together is 200 mA max.

// The 5V output pin is good for ~400 mA on USB, ~900 mA when using an external power adapter.
// The 900 mA is for an adapter that provides ~7V. As the adapter voltage increases, 
// the amount of heat the regulator has to deal with also increases, so the maximum current will drop as the voltage increases.
// This is called thermal limiting.

// The 3.3V output is capable of supplying 150 mA.
// Any power drawn from the 3.3V rail has to go through the 5V rail. Therefore, if you have a 100 mA device on the 3.3V output, you need to also count it against the 5V total current.

// The Uno's ports are 5V outputs.
// Operating Voltage                5V
// Input Voltage (recommended)      7-12V
// Input Voltage (limits)           6-20V

// The ADC resolution (analog read) is set to 10 bits by default. The value can range from 1 to 32.
// we can set resolutions higher than 12 but values returned by analogRead() will suffer approximation.

// The DAC resolution (analog write) is set to 8 bits by default. The value can range from 1 to 32.
// If we choose a resolution higher or lower than your board’s hardware capabilities,
// the value used in analogWrite() will be either truncated if it’s too high or padded with zeros if it’s too low.


void setup() {

}

void loop() {

}
