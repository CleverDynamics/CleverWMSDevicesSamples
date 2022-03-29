# Introduction 
This project is a set of samples intended to demonstrate to developers the various
different means of extending Clever WMS Devices.

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
