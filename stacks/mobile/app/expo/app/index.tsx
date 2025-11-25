import { View, Text, StyleSheet } from 'react-native'

export default function HomeScreen() {
  return (
    <View style={styles.container}>
      <Text style={styles.title}>Welcome to Your App</Text>
      <Text style={styles.subtitle}>Start building something amazing.</Text>
    </View>
  )
}

const styles = StyleSheet.create({
  container: {
    flex: 1,
    alignItems: 'center',
    justifyContent: 'center',
    backgroundColor: '#f9fafb',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#111827',
  },
  subtitle: {
    marginTop: 8,
    fontSize: 16,
    color: '#6b7280',
  },
})
