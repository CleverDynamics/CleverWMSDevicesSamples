# Introduction 
This project is a set of samples intended to demonstrate to developers the various
different means of extending Clever WMS Devices.

## MyFirstDeviceFunction - A simple device function to change an item description
Works across all modern implementations of Clever WMS Devices, particularly in
versions of Business Central where the interface object is not supported.

This example shows how a simple function can be created by subscribing to the
following events in session management:

 - OnFunctionInitialise()
 - OnFunctionValidate()
 - OnFunctionCancel()
 - OnFunctionPost()

The example function accepts an item number, displays the description, and allows
the user to enter a new description.

Before use, add 'MYFUNCTION' to the function codes table, ensure columns have been
added or the data items will not display on the device.

Finally, add 'MYFUNCTION' to a device menu.


## MyFirstDeviceFunctionInterface - A simple device function to change an item description
A more efficient method to implementation a device function utilising interfaces.

Works in modern implementations of Clever WMS Devices, only versions of Business Central
where interface objects is supported.

This example shows how a simple function can be created using a codeunit implementation of
"IFunction CHHFTMN". Required functions:

 - Initialize()
 - Validate()
 - Cancel()
 - Post()
 - Close()

The example function accepts an item number, displays the description, and allows
the user to enter a new description.

Before use, add 'MYFUNCTIONIF' to the function codes table, ensure columns have been
added or the data items will not display on the device.

When creating the function you MUST specify the "Implementation" ('My First Device Function')

Finally, add 'MYFUNCTIONIF' to a device menu.


## GS1BarcodeProcessor - On-server custom barcode processing
Barcodes are usually processed "On-device" and this is the recommended method if
possible, however sometimes companies have created barcodes that do not conform to
standards.

On-server custom barcode processing is designed to handle those non-standard cases.
This functionality should not be used in conjunction with functionality to reduce
round-trips as on-server barcode processing necessitates a round-trip every time.

Barcode processors are company-wide modifications that apply across all handheld
transactions and enquiries. There are two elements:

 - An implementation of a processor conforming to interface
   IBarcodeProcessor CHHFTMN (GS1BarcodeProcessor.codeunit.al).

 - An enum called Barcode Processor CHHFTMN that ties the barcode processor
   implementation to a setting in Handheld Setup (GS1BarcodeProcessor.enum.al).

Barcode processors are switched in and out from "Handheld Setup" by selecting the
processor from field "Barcode Processor".
