import csv
import hdfs
import avro.schema
from hdfs.ext.avro import AvroWriter, AvroReader

client_hdfs = hdfs.InsecureClient('http://192.168.50.120:50070')
airlines = []
schema = avro.schema.parse(open('schema_avro.avsc', "r").read())
with client_hdfs.read('/airlines/airlines.dat', encoding='UTF-8', delimiter='\n') as reader:
	for row in reader:
		if row:
			airlines.append(row)
data = []
csvreader = csv.reader(airlines, quotechar='"')
for row in csvreader:
	data.append({
		"Airline ID": int(row[0]),
		"Name": row[1],
		"Alias": row[2],
		"IATA": row[3],
		"ICAO": row[4],
		"Callsign": row[5],
		"Country": row[6],
		"Active": row[7]
	}
	)
with AvroWriter(client_hdfs, '/airlines/airlines.avro', overwrite=True) as writer:
	for record in data:
		writer.write(record)

with AvroReader(client_hdfs, '/airlines/airlines.avro') as reader:
	for row in reader:
		print(row)








