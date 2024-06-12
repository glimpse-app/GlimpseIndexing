//
//  NewFetchModel.swift
//  GlimpseIndexing
//
//  Created by guestuser on 2024-06-12.
//

import Foundation
import Combine

class ImagesViewModel: ObservableObject{
    @Published var images: [Image]=[]
    @Published var filteredImages: [Image] = []
    @Published var searchTag: String = "" {
        didSet{
            
            
            filterImages()
        }
    }
    
    init(){
        fetchImages()
    }
    
    func fetchImages(){
        let urlString = "http://yourserveraddress/api" // Replace with your server address
        guard let url = URL(string: urlString) else {return}
        
        let task = URLSession.shared.dataTask(with: url){ data, response, error in
            if let error = error{
                print("Error fetching images: \(error)")
                return
            }
            guard let data = data else {return}
            
            do{
                let images = try JSONDecoder().decode([Image].self,from: data)
                DispatchQueue.main.async{
                    self.images = images
                    self.filterImages()
                }
            }catch{
                print("Error decoding JSON: \(error)")
                
            }
        }
        task.resume()
    }
    
    private func filterImages(){
        if searchTag.isEmpty{
            filteredImages = images
        }else{
            filteredImages = images.filter{ $0.tags.contains(searchTag)}
        }
    }
}
        
        
            
            
            
            
            
  
