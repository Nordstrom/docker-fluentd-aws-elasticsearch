@current_dir = File.dirname(__FILE__)
@build_directory = "#{@current_dir}/build"
@proxy = "http://webproxysea.nordstrom.net:8181"

@app_name = File.basename(Dir.getwd)
@version = "1.0"

def create_directory(path)
  Dir.mkdir(path) unless Dir.exist?(path)
end

task :build_image do
	create_directory(@build_directory)

	files = ["Dockerfile", "td-agent.conf", "start-fluentd"]
	files.each do |f|
		if File.exist?(f)
			FileUtils.cp(f, @build_directory)
		end
	end
	
	file = File.join(@build_directory, "start-fluentd")
	File.chmod(0744, file)

	sh "docker build --no-cache \
		--build-arg http_proxy=#{@proxy} \
		--build-arg https_proxy=#{@proxy} \
		-t #{@app_name} #{@build_directory}"
end

task :release_image do
	account = "nordstrom"

	sh "docker tag -f #{@app_name} #{@app_name}:#{@version}"
	sh "docker push #{account}/#{@app_name}:#{@version}"
end

task :build do
  Rake::Task[:build_image].invoke
  Rake::Task[:release_image].invoke
end