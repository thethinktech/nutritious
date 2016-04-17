# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
kitchen = Category.create(name: "Scales and Measuring tools",
 	search_index: "Kitchen",
	keyword: "Digital Kitchen Scale",
	brand: nil
)
["B00XGNETVE", "B00RLDI17S", "B0187NI0I0", "B00S4P7GVY", "B009L1VV3Y"].each do |pid|
	kitchen.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

supplements = Category.create(name: "Supplements",
	search_index: "HealthPersonalCare",
 	keyword: "MegaFood",
 	brand: "MegaFood")
["B00GZ9JTRA", "B00GZ9JZJM", "B00GZ9H8GE", "B00GZ9KQPY", "B00GZ9K23A", "B00L8AZIXK", "B00L8AZIXK", "B00GZ9KC6W", "B00GZ9JU74"].each do |pid|
	supplements.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

house_holds = Category.create(name: "Household cleaning Products",
 	search_index: "HealthPersonalCare",
 	keyword: "Legacy of Clean",
 	brand: "Legacy of Clean")
["B007USP0QO", "B00J6Z6YLE", "B008EE4S2U", "B00I1JWWXU", "B003EWHE82", "B00J6G7ZSE"].each do |pid|
	house_holds.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

res_rem = Category.create(name: "Rescue Remedy",
	search_index: "HealthPersonalCare",
 	keyword: "Rescue Remedy",
 	brand: "Bach")
["B00016QT7Q", "B004151F8Q", "B004RRG2PE", "B00EEEFUZI", "B00DEYEREY", "B001G7QZSW", "B003TVJJ0Y"].each do |pid|
	res_rem.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

teas= Category.create(name: "Teas",
	search_index: "HealthPersonalCare",
 	keyword: "Mighty Leaf Tea",
 	brand: "Mighty Leaf Tea")
["B004SIAOG0", "B000GBYZYU", "B000DZB16E", "B000GC1XZI", "B001UK2EU8", "B004T337ZE"].each do |pid|
	teas.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

beauty = Category.create(name: "Beauties",
 	search_index: "Beauty",
 	keyword: "avalon organics vit c",
 	brand: "Avalon Organics")
["B0014H2ZV0", "B001T8JW6U", "B00005LBRR", "B001ET72X4", "B00005LBRT"].each do |pid|
	beauty.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

baby= Category.create(name: "Babyganics",
 	search_index: "Baby",
	keyword: "Babyganics Multi Surface Cleaner",
	brand: "Babyganics")
["B0038QQ7K0", "B00T2CFQTM", "B00T2CFQUQ", "B0038QQ7QE", "B00FSCB3PG"].each do |pid|
	baby.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

tradionals = Category.create(name: "Traditional medicinal",
 	search_index: "HealthPersonalCare",
 	keyword: "Traditional Medicinals Organic",
 	brand: "Traditional Medicinals")
["B0009F3PJ4", "B007IW25FQ", "B000EJPDFY", "B0009F3S7I"].each do |pid|
	tradionals.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

fitness = Category.create(name: "Fitness",
 	search_index: "HealthPersonalCare",
	keyword: "Vega Sport Recovery Accelerator",
	brand: "Vega")
["B005O4ZJAS", "B005H6UCHS", "B005MJCLMY", "B005P0K67W"].each do |pid|
	fitness.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end

emc = Category.create(name: "Emergen C",
 	search_index: "HealthPersonalCare",
  	keyword: "Emergen C",
  	brand: "Alacer")
["B00WC7ZZFO", "B000IXOE6U", "B0052P0P62", "B004L56DT2"].each do |pid|
	emc.aws_product_lookups << AwsProductLookup.create(product_id: pid)
end
