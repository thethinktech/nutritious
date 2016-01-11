Rake::Task['assets:clean'].enhance do
  Rake::Task['assets:clobber'].invoke
end