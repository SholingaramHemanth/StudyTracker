"use client"

import { useStudy } from '@/lib/study-context'
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card'
import { Button } from '@/components/ui/button'
import { Bell, Camera, Download, Map as MapIcon, Moon, Sun, Upload, LogOut } from 'lucide-react'
import { useTheme } from "next-themes"

export function SettingsPage() {
                  const { logout, offlineMode, toggleOfflineMode } = useStudy()
                  const { theme, setTheme } = useTheme()

                  // Native feature mocks
                  const requestNotificationPermission = () => {
                                    if ('Notification' in window) {
                                                      Notification.requestPermission().then(permission => {
                                                                        if (permission === 'granted') {
                                                                                          alert('Push notifications enabled for your device!')
                                                                        }
                                                      })
                                    } else {
                                                      alert('Notifications are not supported on this device.')
                                    }
                  }

                  const openCameraMock = () => {
                                    // In a real PWA or Cordova/Capacitor app, this would trigger native camera intent
                                    alert('Native Camera integration triggered for scanning notes/questions.')
                  }

                  const handleFileUpload = () => {
                                    // Trigger native file picker
                                    alert('Native File System picker triggered for document upload.')
                  }

                  const requestLocation = () => {
                                    if ('geolocation' in navigator) {
                                                      navigator.geolocation.getCurrentPosition(() => {
                                                                        alert('Location accessed for finding nearby study groups.')
                                                      })
                                    }
                  }

                  return (
                                    <div className="max-w-2xl mx-auto space-y-6 pb-20">
                                                      <div>
                                                                        <h2 className="text-2xl font-bold tracking-tight">App Settings</h2>
                                                                        <p className="text-muted-foreground">Manage your mobile application preferences.</p>
                                                      </div>

                                                      <div className="grid gap-6">
                                                                        {/* Appearance & Theme */}
                                                                        <Card className="border-border/50">
                                                                                          <CardHeader>
                                                                                                            <CardTitle className="text-lg flex items-center gap-2">Appearance</CardTitle>
                                                                                                            <CardDescription>Customize the look and feel of the app.</CardDescription>
                                                                                          </CardHeader>
                                                                                          <CardContent className="space-y-4">
                                                                                                            <div className="flex items-center justify-between">
                                                                                                                              <span className="font-medium text-sm">Theme</span>
                                                                                                                              <div className="flex bg-muted rounded-full p-1 border">
                                                                                                                                                <button
                                                                                                                                                                  onClick={() => setTheme("light")}
                                                                                                                                                                  className={`flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${theme === 'light' ? 'bg-background shadow-sm' : 'text-muted-foreground hover:text-foreground'}`}
                                                                                                                                                >
                                                                                                                                                                  <Sun className="w-4 h-4" /> Light
                                                                                                                                                </button>
                                                                                                                                                <button
                                                                                                                                                                  onClick={() => setTheme("dark")}
                                                                                                                                                                  className={`flex items-center gap-2 px-3 py-1.5 rounded-full text-xs font-medium transition-colors ${theme === 'dark' ? 'bg-background shadow-sm' : 'text-muted-foreground hover:text-foreground'}`}
                                                                                                                                                >
                                                                                                                                                                  <Moon className="w-4 h-4" /> Dark
                                                                                                                                                </button>
                                                                                                                              </div>
                                                                                                            </div>
                                                                                          </CardContent>
                                                                        </Card>

                                                                        {/* Offline & Performance */}
                                                                        <Card className="border-border/50">
                                                                                          <CardHeader>
                                                                                                            <CardTitle className="text-lg flex items-center gap-2">Data & Storage</CardTitle>
                                                                                                            <CardDescription>Manage offline capabilities and caching.</CardDescription>
                                                                                          </CardHeader>
                                                                                          <CardContent className="space-y-4">
                                                                                                            <div className="flex items-center justify-between">
                                                                                                                              <div className="space-y-0.5">
                                                                                                                                                <span className="font-medium text-sm block">Offline Mode</span>
                                                                                                                                                <span className="text-xs text-muted-foreground block">Cache important pages for offline use</span>
                                                                                                                              </div>
                                                                                                                              <Button
                                                                                                                                                variant={offlineMode ? "default" : "outline"}
                                                                                                                                                size="sm"
                                                                                                                                                onClick={toggleOfflineMode}
                                                                                                                                                className="gap-2"
                                                                                                                              >
                                                                                                                                                <Download className="w-4 h-4" /> {offlineMode ? 'Enabled' : 'Enable'}
                                                                                                                              </Button>
                                                                                                            </div>
                                                                                          </CardContent>
                                                                        </Card>

                                                                        {/* Native Integrations */}
                                                                        <Card className="border-border/50">
                                                                                          <CardHeader>
                                                                                                            <CardTitle className="text-lg flex items-center gap-2">Device Features</CardTitle>
                                                                                                            <CardDescription>Allow the app to access your smartphone's hardware.</CardDescription>
                                                                                          </CardHeader>
                                                                                          <CardContent className="space-y-4">
                                                                                                            <div className="grid grid-cols-2 gap-4">
                                                                                                                              <Button variant="outline" className="justify-start gap-2 h-auto py-3 px-4" onClick={requestNotificationPermission}>
                                                                                                                                                <div className="bg-blue-500/10 p-2 rounded-lg text-blue-500"><Bell className="w-5 h-5" /></div>
                                                                                                                                                <div className="text-left"><span className="block text-sm font-semibold">Push Alerts</span><span className="block text-[10px] text-muted-foreground">Notifications</span></div>
                                                                                                                              </Button>
                                                                                                                              <Button variant="outline" className="justify-start gap-2 h-auto py-3 px-4" onClick={openCameraMock}>
                                                                                                                                                <div className="bg-emerald-500/10 p-2 rounded-lg text-emerald-500"><Camera className="w-5 h-5" /></div>
                                                                                                                                                <div className="text-left"><span className="block text-sm font-semibold">Scanner</span><span className="block text-[10px] text-muted-foreground">Camera Access</span></div>
                                                                                                                              </Button>
                                                                                                                              <Button variant="outline" className="justify-start gap-2 h-auto py-3 px-4" onClick={handleFileUpload}>
                                                                                                                                                <div className="bg-orange-500/10 p-2 rounded-lg text-orange-500"><Upload className="w-5 h-5" /></div>
                                                                                                                                                <div className="text-left"><span className="block text-sm font-semibold">Uploads</span><span className="block text-[10px] text-muted-foreground">File System</span></div>
                                                                                                                              </Button>
                                                                                                                              <Button variant="outline" className="justify-start gap-2 h-auto py-3 px-4" onClick={requestLocation}>
                                                                                                                                                <div className="bg-purple-500/10 p-2 rounded-lg text-purple-500"><MapIcon className="w-5 h-5" /></div>
                                                                                                                                                <div className="text-left"><span className="block text-sm font-semibold">Location</span><span className="block text-[10px] text-muted-foreground">Study Groups</span></div>
                                                                                                                              </Button>
                                                                                                            </div>
                                                                                          </CardContent>
                                                                        </Card>

                                                                        {/* Account */}
                                                                        <div className="pt-4">
                                                                                          <Button variant="destructive" className="w-full gap-2" onClick={logout}>
                                                                                                            <LogOut className="w-4 h-4" /> Sign Out
                                                                                          </Button>
                                                                        </div>
                                                      </div>
                                    </div>
                  )
}
