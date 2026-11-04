local file_manager = {}
function file_manager.listdir(path) return {} end
function file_manager.isfile(path) return false end
function file_manager.readfile(path) return "" end
return file_manager
